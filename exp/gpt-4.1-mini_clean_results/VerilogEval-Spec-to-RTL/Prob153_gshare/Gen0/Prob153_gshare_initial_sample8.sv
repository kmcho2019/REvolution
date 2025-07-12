module TopModule(
    input        clk,
    input        areset,
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

// 2-bit saturating counter states
localparam WEAK_NOT_TAKEN = 2'd1;
localparam WEAK_TAKEN     = 2'd2;

// PHT memory
reg [1:0] pht [0:127];
// Global history register
reg [6:0] ghr, ghr_next;

// Wires for indexing
wire [6:0] predict_index = predict_pc ^ ghr;
wire [6:0] train_index   = train_pc ^ train_history;

// Prediction register to hold current prediction output from PHT
reg [1:0] predict_counter;
reg [6:0] predict_ghr_reg;

// Output assignments
assign predict_taken   = predict_counter[1]; // MSB of saturating counter
assign predict_history = predict_ghr_reg;

// Read PHT entry for prediction combinationally
wire [1:0] pht_predict_entry;
assign pht_predict_entry = pht[predict_index];

// Prediction combinational logic: register the prediction outputs when predict_valid
always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_counter <= 2'd0;
        predict_ghr_reg <= 7'd0;
    end else if (predict_valid) begin
        // Prediction output reflects PHT entry before any updates in this cycle
        predict_counter <= pht_predict_entry;
        predict_ghr_reg <= ghr;
    end
end

// Initialize PHT and GHR on reset
integer i;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'd0;
        for (i=0; i<128; i=i+1)
            pht[i] <= 2'd2; // Initialize to weakly taken (2)
    end else begin
        // Update PHT on training
        if (train_valid) begin
            // Read old counter
            reg [1:0] old_ctr;
            old_ctr = pht[train_index];
            // Update saturating counter based on train_taken
            if (train_taken) begin
                // increment saturating counter unless already max
                if (old_ctr != 2'd3)
                    pht[train_index] <= old_ctr + 1;
                else
                    pht[train_index] <= old_ctr;
            end else begin
                // decrement saturating counter unless already 0
                if (old_ctr != 2'd0)
                    pht[train_index] <= old_ctr - 1;
                else
                    pht[train_index] <= old_ctr;
            end
        end

        // Update GHR
        // Priority: if train_mispredicted & train_valid, recover GHR to train_history
        // else if predict_valid and not train_mispredicted training, update GHR with predicted taken bit
        if (train_valid && train_mispredicted) begin
            // Recover GHR
            ghr <= train_history;
        end else if (predict_valid) begin
            // Update GHR with predicted taken bit (MSB of PHT entry for predict_index)
            // The prediction used is from current cycle outputs (before update)
            // The bit to insert is predict_taken from the last clock cycle
            // But per description, update GHR with predicted branch direction at next clk edge
            // Here, using pht[predict_index] as current PHT state, output MSB as predicted bit
            // This matches the spec since PHT updates on next edge, so current prediction is stable
            ghr <= {ghr[5:0], pht[predict_index][1]};
        end
    end
end

endmodule