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

// Internal signals and registers
reg [6:0] global_history;
reg [6:0] global_history_next;
reg [127:0] [1:0] pht;
reg [1:0] pht_out;

// Index calculation
wire [6:0] index;
assign index = predict_pc ^ global_history;

// Prediction logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken};
    end
end

assign predict_taken = (pht[index] == 2'b11 || pht[index] == 2'b10);
assign predict_history = global_history;

// Training logic
always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken && train_mispredicted) begin
            if (pht[train_pc ^ train_history] != 2'b11) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 2'b01;
            end
        end else if (!train_taken && train_mispredicted) begin
            if (pht[train_pc ^ train_history] != 2'b00) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 2'b01;
            end
        end
    end
end

// Initialize PHT
initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b01;
    end
end

endmodule