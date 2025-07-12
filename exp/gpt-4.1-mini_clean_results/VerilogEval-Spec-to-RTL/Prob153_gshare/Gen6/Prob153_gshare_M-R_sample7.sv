module TopModule (
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

    // Saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // PHT memory: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // GHR speculative register
    reg [6:0] ghr_spec;

    // Prediction address and GHR pipeline registers (to handle synchronous RAM read latency)
    reg predict_valid_r;
    reg [6:0] predict_pc_r;
    reg [6:0] predict_ghr_r;

    // PHT read address register (synchronous RAM style)
    reg [6:0] pht_read_addr;
    wire [1:0] pht_read_data = pht[pht_read_addr];

    // Computed indices for training
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update functions
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    // Combinational predicted index from current GHR
    wire [6:0] predict_index = predict_pc ^ ghr_spec;

    // Combinational predicted counter output (read from PHT in previous cycle)
    // This read data corresponds to predict_index registered last cycle
    wire predict_taken_next = pht_read_data[1];

    // Outputs registers to hold stable outputs aligned with prediction timing
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    integer i;

    // Sequential logic: synchronous reset, PHT update, GHR update, pipeline registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
            ghr_spec <= 7'b0;

            predict_valid_r <= 1'b0;
            predict_pc_r <= 7'b0;
            predict_ghr_r <= 7'b0;

            pht_read_addr <= 7'b0;

            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Register prediction input and GHR to pipeline prediction request:
            // This lets us output prediction result corresponding to that request next cycle
            predict_valid_r <= predict_valid;
            predict_pc_r <= predict_pc;
            predict_ghr_r <= ghr_spec;

            // Register PHT read address to perform synchronous read
            // For the prediction made last cycle
            if (predict_valid)
                pht_read_addr <= predict_pc ^ ghr_spec;
            else
                pht_read_addr <= pht_read_addr; // hold

            // Update PHT on training
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update speculative GHR
            // Priority: If training with misprediction, restore GHR to train_history
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted bit from *current* prediction
                // Note: pht_read_data corresponds to last cycle's prediction index,
                // but ghr_spec updated here uses current cycle's prediction.
                // So we must use combinational prediction:
                // Actually, predict_taken_next is pht_read_data from previous cycle's predict_index.
                // To get prediction for current cycle's predict_index, use pht[predict_index] directly.

                // Instead of complicated double-cycle latency, update ghr_spec with prediction computed from current GHR & PC:
                // Access pht combinationally here:
                // This is safe because pht is a reg array, can read combinationally in simulation.
                // In synthesis, inferred RAM usually does not allow combinational read;
                // for simplicity and matching problem requirements, we accept this.

                reg [1:0] current_pht_entry;
                current_pht_entry = pht[predict_pc ^ ghr_spec];
                ghr_spec <= {ghr_spec[5:0], current_pht_entry[1]};
            end
            // else hold ghr_spec

            // Output registered prediction results from last cycle's prediction input and PHT read
            if (predict_valid_r) begin
                predict_taken_reg <= pht_read_data[1];
                predict_history_reg <= predict_ghr_r;
            end
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule