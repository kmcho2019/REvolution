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

// Internal signals and variables
reg [6:0] global_history;
reg [6:0] pht_index;
reg [1:0] pht_value;
reg [6:0] pht_index_next;
reg [1:0] pht_value_next;
reg [6:0] next_global_history;

// PHT (Pattern History Table)
reg [1:0] pht[127:0];

// Initialize PHT with zeros
initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b00;
    end
end

// Calculate PHT index
assign pht_index = predict_pc[6:0] ^ global_history;

// Predict taken
assign predict_taken = (pht[pht_index] == 2'b11 || pht[pht_index] == 2'b10);

// Predict history
assign predict_history = global_history;

// Next global history
assign next_global_history = (train_mispredicted) ? train_history : (global_history << 1) | predict_taken;

// Training logic
always @(*) begin
    if (train_valid) begin
        pht_index_next = train_pc[6:0] ^ train_history;
        if (train_taken) begin
            if (pht[pht_index_next] == 2'b11) begin
                pht_value_next = 2'b11;
            end else begin
                pht_value_next = pht[pht_index_next] + 1'b1;
            end
        end else begin
            if (pht[pht_index_next] == 2'b00) begin
                pht_value_next = 2'b00;
            end else begin
                pht_value_next = pht[pht_index_next] - 1'b1;
            end
        end
    end else begin
        pht_index_next = pht_index;
        pht_value_next = pht[pht_index];
    end
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= next_global_history;
    end

    if (train_valid) begin
        pht[pht_index_next] <= pht_value_next;
    end
end

endmodule