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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register (speculative)
    reg [6:0] ghr;

    // Predict history output registered at clock edge
    reg [6:0] predict_history_reg;

    // Calculate indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Asynchronous reads for prediction and training indices
    wire [1:0] pht_predict_state = pht[predict_index];

    // Output assignment
    assign predict_taken = predict_valid ? pht_predict_state[1] : 1'b0;
    assign predict_history = predict_history_reg;

    // Saturating counter update helper
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            else        saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i=0; i<128; i=i+1)
                pht[i] <= 2'b01;    // weakly not taken
            ghr <= 7'd0;
            predict_history_reg <= 7'd0;
        end else begin
            // Register predict_history output as ghr before update, but only if predict_valid
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update PHT on training
            if (train_valid)
                pht[train_index] <= saturate_update(pht[train_index], train_taken);

            // Update global history register with priority:
            // training (including recovery on misprediction) takes precedence over prediction
            if (train_valid) begin
                if (train_mispredicted)
                    ghr <= train_history;
                else
                    ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht_predict_state[1]};
            end
            // else no update to ghr
        end
    end

endmodule