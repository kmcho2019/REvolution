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

    // Global History Register
    reg [6:0] ghr;
    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];

    // Prediction path (combinational)
    wire [6:0] predict_idx = predict_pc ^ ghr;
    assign predict_taken = pht[predict_idx][1];
    assign predict_history = ghr;

    // Training path
    wire [6:0] train_idx = train_pc ^ train_history;
    wire [1:0] next_pht_state;

    // Calculate next PHT state with saturation
    assign next_pht_state = 
        train_taken ? 
            (pht[train_idx] == 2'b11) ? 2'b11 : (pht[train_idx] + 1) :
            (pht[train_idx] == 2'b00) ? 2'b00 : (pht[train_idx] - 1);

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT using generate
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end
        else if (train_valid) begin
            pht[train_idx] <= next_pht_state;
        end
    end

    // Next GHR value calculation
    wire [6:0] next_ghr;
    assign next_ghr = 
        (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
        predict_valid ? {ghr[5:0], predict_taken} :
        ghr;

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end
        else begin
            ghr <= next_ghr;
        end
    end

endmodule