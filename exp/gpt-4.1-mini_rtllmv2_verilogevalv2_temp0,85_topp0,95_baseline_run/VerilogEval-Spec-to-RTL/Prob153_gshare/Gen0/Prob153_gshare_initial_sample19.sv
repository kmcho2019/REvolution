module TopModule(
    input        clk,
    input        areset,

    // Prediction interface
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    // Training interface
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    // 2'b00: strongly not taken
    // 2'b01: weakly not taken
    // 2'b10: weakly taken
    // 2'b11: strongly taken
    reg [1:0] PHT [0:127];
    reg [6:0] GHR; // global history register

    wire [6:0] predict_index;
    wire [6:0] train_index;

    // Compute indices by XOR of PC and history
    assign predict_index = predict_pc ^ GHR;
    assign train_index   = train_pc ^ train_history;

    // Read PHT entry for prediction (combinational)
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction is taken if MSB of counter is 1
    assign predict_taken = (predict_counter[1] == 1'b1);
    assign predict_history = GHR;

    // Next predicted branch outcome (1 for taken, 0 for not taken)
    wire predict_outcome = predict_taken;

    integer i;

    // On asynchronous reset, initialize GHR and PHT entries
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                // Initialize to weakly taken (2'b10) for better prediction start
                PHT[i] <= 2'b10;
            end
        end else begin
            // Update PHT if training valid: update saturating counter at train_index
            if (train_valid) begin
                // Current counter
                case (PHT[train_index])
                    2'b00: PHT[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: PHT[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: PHT[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: PHT[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end

            // Update GHR (global history register)
            // If train_mispredicted is asserted with train_valid, restore GHR to train_history
            // Else if predict_valid, shift in predicted outcome
            if (train_valid && train_mispredicted) begin
                // Recover history to state immediately after mispredicted branch completes
                GHR <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted outcome into GHR
                GHR <= {GHR[5:0], predict_outcome};
            end
            // else no change to GHR
        end
    end

endmodule