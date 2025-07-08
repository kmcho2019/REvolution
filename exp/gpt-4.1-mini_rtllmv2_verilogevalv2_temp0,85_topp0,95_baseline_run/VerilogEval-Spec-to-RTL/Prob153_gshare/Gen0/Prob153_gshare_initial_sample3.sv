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

// PHT: 128 entries of 2-bit saturating counters
// 00 - strongly not taken
// 01 - weakly not taken
// 10 - weakly taken
// 11 - strongly taken

reg [1:0] PHT [0:127];
reg [6:0] global_history;

wire [6:0] predict_index = predict_pc ^ global_history;
wire [6:0] train_index   = train_pc ^ train_history;

wire [1:0] predict_counter = PHT[predict_index];
wire       predict_dir = predict_counter[1]; // MSB is prediction

assign predict_taken = (predict_valid) ? predict_dir : 1'b0;
assign predict_history = global_history;

// Combinational logic to compute new PHT counter value for training update
reg [1:0] pht_counter_next;
always @(*) begin
    pht_counter_next = PHT[train_index];
    if (train_valid) begin
        if (train_taken) begin
            // Increment saturating counter (max 3)
            if (pht_counter_next != 2'b11)
                pht_counter_next = pht_counter_next + 1'b1;
        end else begin
            // Decrement saturating counter (min 0)
            if (pht_counter_next != 2'b00)
                pht_counter_next = pht_counter_next - 1'b1;
        end
    end
end

// New global history update values
wire predicted_taken_next = predict_dir;
wire [6:0] predicted_history_next = {global_history[5:0], predicted_taken_next};

// In next cycle, update global history and PHT
always @(posedge clk or posedge areset) begin
    integer i;
    if (areset) begin
        global_history <= 7'b0;
        for (i=0; i<128; i=i+1) begin
            PHT[i] <= 2'b10; // weakly taken
        end
    end else begin
        // Update PHT entry if training valid
        if (train_valid) begin
            PHT[train_index] <= pht_counter_next;
        end

        // Update global history with priority:
        // If mispredicted training, set global_history to train_history
        // Else if prediction valid (and no mispredicted training), update with predicted_taken
        if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            // Only update global history with prediction if no mispredicted training in same cycle
            if (!(train_valid && train_mispredicted)) begin
                global_history <= predicted_history_next;
            end
        end
    end
end

endmodule