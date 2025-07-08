module TopModule (
    input  wire        clk,
    input  wire        areset,

    input  wire        predict_valid,
    input  wire [6:0]  predict_pc,
    output wire        predict_taken,
    output wire [6:0]  predict_history,

    input  wire        train_valid,
    input  wire        train_taken,
    input  wire        train_mispredicted,
    input  wire [6:0]  train_history,
    input  wire [6:0]  train_pc
);

    // Two-bit saturating counters:
    // 2'b00 = strongly not taken
    // 2'b01 = weakly not taken
    // 2'b10 = weakly taken
    // 2'b11 = strongly taken

    // PHT: 128 entries of 2 bits
    reg [1:0] pht [0:127];

    // Global history register (7 bits)
    reg [6:0] ghist;

    // Compute indices:
    wire [6:0] predict_index = predict_pc ^ ghist;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entries
    wire [1:0] predict_pht_entry = pht[predict_index];
    wire [1:0] train_pht_entry = pht[train_index];

    // Prediction logic: taken if MSB of saturating counter is 1
    assign predict_taken = (predict_pht_entry[1] == 1'b1);
    assign predict_history = ghist;

    // Next state of saturating counters function
    function [1:0] saturating_counter_update;
        input [1:0] curr_state;
        input       taken;
        begin
            case (curr_state)
                2'b00: saturating_counter_update = taken ? 2'b01 : 2'b00;
                2'b01: saturating_counter_update = taken ? 2'b10 : 2'b00;
                2'b10: saturating_counter_update = taken ? 2'b11 : 2'b01;
                2'b11: saturating_counter_update = taken ? 2'b11 : 2'b10;
                default: saturating_counter_update = 2'b00;
            endcase
        end
    endfunction

    integer i;

    // Sequential logic: update PHT and global history
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT and global history
            ghist <= 7'b0;
            for (i=0; i<128; i=i+1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                // Update PHT entry indexed by train_index
                pht[train_index] <= saturating_counter_update(train_pht_entry, train_taken);
            end

            // Update global history register
            // Priority: if training valid & mispredicted, restore history to train_history
            // else if predict_valid (and no mispredict training), update history with predicted taken
            if (train_valid && train_mispredicted) begin
                // Recover global history after mispredicted branch completes execution
                ghist <= train_history;
            end else if (predict_valid) begin
                ghist <= {ghist[5:0], predict_taken};
            end
            // else ghist remains unchanged
        end
    end

endmodule