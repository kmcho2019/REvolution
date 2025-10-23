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

// Parameters for 2-bit saturating counter states
localparam COUNTER_BITS = 2;
localparam PHT_SIZE = 128;

localparam WEAK_NOT_TAKEN = 2'd1;
localparam WEAK_TAKEN     = 2'd2;

// Pattern History Table (PHT): synchronous RAM with separate read/write port
reg [COUNTER_BITS-1:0] pht_mem [0:PHT_SIZE-1];

// Global History Register (GHR)
reg [6:0] ghr;

// Registered prediction index and GHR used for prediction
reg [6:0] predict_index_reg;
reg [6:0] predict_ghr_reg;

// Registered saturating counter output for prediction
reg [COUNTER_BITS-1:0] predict_counter_reg;

// Compute indexes
wire [6:0] predict_index = predict_pc ^ ghr;
wire [6:0] train_index   = train_pc ^ train_history;

// PHT read data for prediction - registered output of synchronous RAM
wire [COUNTER_BITS-1:0] pht_read_data;
assign pht_read_data = pht_mem[predict_index_reg];

// Outputs
assign predict_taken   = predict_counter_reg[1]; // MSB of 2-bit saturating counter
assign predict_history = predict_ghr_reg;

// Initialization integer for loops
integer i;

// PHT initialization and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize PHT entries to weakly taken (2)
        for (i=0; i<PHT_SIZE; i=i+1) begin
            pht_mem[i] <= WEAK_TAKEN;
        end
        ghr <= 7'd0;

        // Clear prediction registers
        predict_index_reg <= 7'd0;
        predict_ghr_reg <= 7'd0;
        predict_counter_reg <= WEAK_NOT_TAKEN;
    end else begin
        // Prediction index and GHR registers update on predict_valid
        if (predict_valid) begin
            predict_index_reg <= predict_index;
            predict_ghr_reg <= ghr;
            // predict_counter_reg will be updated below after synchronous PHT read
        end

        // Update predict_counter_reg with PHT read data from registered address
        // If no new predict_valid, keep previous counter output
        if (predict_valid) begin
            predict_counter_reg <= pht_mem[predict_index];
        end

        // Training: update saturating counter in PHT
        if (train_valid) begin
            // Current counter before update
            reg [COUNTER_BITS-1:0] old_ctr;
            old_ctr = pht_mem[train_index];

            // Compute new counter value with saturating behavior
            if (train_taken) begin
                // increment saturating counter (max 3)
                if (old_ctr != 2'd3)
                    pht_mem[train_index] <= old_ctr + 1;
                else
                    pht_mem[train_index] <= old_ctr;
            end else begin
                // decrement saturating counter (min 0)
                if (old_ctr != 2'd0)
                    pht_mem[train_index] <= old_ctr - 1;
                else
                    pht_mem[train_index] <= old_ctr;
            end
        end

        // Update GHR with priority:
        // 1) If training and misprediction, recover GHR to train_history
        // 2) Else if predict_valid, update GHR with predicted taken bit
        if (train_valid && train_mispredicted) begin
            ghr <= train_history;
        end else if (predict_valid) begin
            // Shift in predicted taken bit into GHR
            // Use the predicted bit from the registered PHT counter (before update)
            // Note: pht_mem[predict_index] read at posedge clk still returns old data before training write,
            // but we use predict_counter_reg which is updated synchronously at posedge clk with that old data
            ghr <= {ghr[5:0], predict_counter_reg[1]};
        end
    end
end

endmodule