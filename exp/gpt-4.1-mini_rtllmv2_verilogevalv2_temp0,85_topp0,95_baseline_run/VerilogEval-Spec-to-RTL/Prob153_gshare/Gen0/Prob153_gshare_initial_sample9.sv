module TopModule(
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

    // Global history register
    reg [6:0] ghr;

    // Pattern History Table: 128 entries of 2-bit saturating counters
    // Encoding: 2'b00 Strong Not Taken, 01 Weak Not Taken, 10 Weak Taken, 11 Strong Taken
    reg [1:0] pht [0:127];

    // Compute indexes for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] predict_pht_entry = pht[predict_index];
    wire [1:0] train_pht_entry = pht[train_index];

    // Prediction logic: taken if MSB of saturating counter is 1
    assign predict_taken = predict_valid ? predict_pht_entry[1] : 1'b0;

    // Output the GHR used for the prediction (the current ghr)
    assign predict_history = ghr;

    // Function for saturating counter update
    function [1:0] saturating_update;
        input [1:0] counter;
        input taken;
        begin
            case(counter)
                2'b00: saturating_update = taken ? 2'b01 : 2'b00;
                2'b01: saturating_update = taken ? 2'b10 : 2'b00;
                2'b10: saturating_update = taken ? 2'b11 : 2'b01;
                2'b11: saturating_update = taken ? 2'b11 : 2'b10;
                default: saturating_update = 2'b10;
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT entries
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i +1) begin
                pht[i] <= 2'b10; // weakly taken
            end
        end else begin
            // Train PHT if valid
            if (train_valid) begin
                pht[train_index] <= saturating_update(pht[train_index], train_taken);
            end

            // Update GHR:
            // If train_valid & train_mispredicted => recover GHR to train_history (priority)
            // Else if predict_valid => update GHR with predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
            // Else no change to GHR
        end
    end

endmodule