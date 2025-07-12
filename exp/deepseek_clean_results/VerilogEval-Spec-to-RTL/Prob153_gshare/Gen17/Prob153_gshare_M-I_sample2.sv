module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    parameter PHT_SIZE = 128;
    parameter PHT_INIT = 2'b01;  // Weakly not-taken
    
    // Global History Register
    reg [6:0] ghr;
    // Pattern History Table with clock gating
    reg [1:0] pht [0:PHT_SIZE-1];
    reg pht_clock_en;

    // Pipeline registers for prediction path
    reg predict_taken_reg;
    reg [6:0] predict_idx_reg;
    
    // Prediction index and output
    wire [6:0] predict_idx = predict_pc ^ ghr;
    assign predict_taken = predict_taken_reg;
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_idx = train_pc ^ train_history;

    // Clock gating control
    always @(*) begin
        pht_clock_en = areset || train_valid;
    end

    // PHT update logic with staggered reset
    integer init_counter;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            init_counter <= 0;
            if (init_counter < PHT_SIZE) begin
                pht[init_counter] <= PHT_INIT;
                init_counter <= init_counter + 1;
            end
        end
        else if (train_valid) begin
            // Optimized saturation counter update
            if (train_taken) begin
                pht[train_idx] <= (pht[train_idx] == 2'b11) ? 2'b11 : (pht[train_idx] + 1);
            end else begin
                pht[train_idx] <= (pht[train_idx] == 2'b00) ? 2'b00 : (pht[train_idx] - 1);
            end
        end
    end

    // Prediction pipeline register
    always @(posedge clk) begin
        if (predict_valid) begin
            predict_taken_reg <= pht[predict_idx][1];
            predict_idx_reg <= predict_idx;
        end
    end

    // Optimized GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end
        else if (train_valid && train_mispredicted) begin
            ghr <= {train_history[5:0], train_taken};
        end
        else if (predict_valid && !(train_valid && train_mispredicted)) begin
            ghr <= {ghr[5:0], pht[predict_idx][1]};
        end
    end

endmodule