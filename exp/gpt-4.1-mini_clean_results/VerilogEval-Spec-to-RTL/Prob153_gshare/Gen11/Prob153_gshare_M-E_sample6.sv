module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // 2-bit saturating counters:
    // 00 = Strongly Not Taken
    // 01 = Weakly Not Taken
    // 10 = Weakly Taken
    // 11 = Strongly Taken

    reg [1:0] pht [0:127];

    reg [6:0] ghr; // Committed global history register

    // Registers to hold prediction outputs stable for one cycle
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Index calculation
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entry for prediction at current cycle
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire       predicted_taken_bit = pht_predict_entry[1]; // MSB determines taken

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? state : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? state : state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b10; // Initialize to weakly taken
        end else begin
            // Update PHT entry on training if valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update global history with priority
            if (train_valid && train_mispredicted) begin
                // On misprediction training, recover ghr to train_history
                ghr <= train_history;
            end else if (train_valid) begin
                // On normal training, shift in the actual outcome
                ghr <= {ghr[5:0], train_taken};
            end

            // Update prediction output registers if prediction valid
            // This stores the outputs corresponding to the time the prediction was made
            if (predict_valid) begin
                predict_taken_reg <= predicted_taken_bit;
                predict_history_reg <= ghr;
            end
        end
    end

    // Output the latched prediction results
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule