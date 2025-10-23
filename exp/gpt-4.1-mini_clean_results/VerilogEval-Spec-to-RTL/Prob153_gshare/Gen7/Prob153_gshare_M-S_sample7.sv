module TopModule (
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

    // Saturating counter states (2-bit saturating counters)
    localparam [1:0]
        SN = 2'b00, // Strongly Not Taken
        WN = 2'b01, // Weakly Not Taken
        WT = 2'b10, // Weakly Taken
        ST = 2'b11; // Strongly Taken

    // Pattern History Table (128 entries)
    reg [1:0] pht [0:127];

    // Global history register (speculative)
    reg [6:0] ghr;

    integer i;

    // Saturating increment
    function [1:0] sat_inc(input [1:0] val);
        if (val == ST) sat_inc = ST;
        else sat_inc = val + 1'b1;
    endfunction

    // Saturating decrement
    function [1:0] sat_dec(input [1:0] val);
        if (val == SN) sat_dec = SN;
        else sat_dec = val - 1'b1;
    endfunction

    // Compute PHT index for prediction (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Predict taken based on MSB of PHT entry for index
    wire [1:0] predict_counter = pht[predict_index];
    wire       predict_taken_wire = predict_counter[1];

    // Compute PHT index for training (combinational)
    wire [6:0] train_index = train_pc ^ train_history;

    // Output assignment
    assign predict_taken = predict_valid ? predict_taken_wire : 1'b0;
    assign predict_history = ghr;

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WT;
            ghr <= 7'b0;
        end else begin
            // Training update takes precedence
            if (train_valid) begin
                // Update PHT entry at train_index
                if (train_taken)
                    pht[train_index] <= sat_inc(pht[train_index]);
                else
                    pht[train_index] <= sat_dec(pht[train_index]);

                // If mispredicted, recover history
                if (train_mispredicted) begin
                    ghr <= train_history;
                end else begin
                    // Otherwise update history speculatively with prediction if no mispredict
                    if (predict_valid) begin
                        // Update ghr with prediction outcome
                        ghr <= {ghr[5:0], predict_taken_wire};
                    end
                    // else hold ghr
                end
            end else begin
                // No training: update ghr only on prediction
                if (predict_valid) begin
                    ghr <= {ghr[5:0], predict_taken_wire};
                end
                // else hold ghr
            end
        end
    end

endmodule