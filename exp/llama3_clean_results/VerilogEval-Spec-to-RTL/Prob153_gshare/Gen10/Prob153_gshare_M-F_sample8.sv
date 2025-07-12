// Top-level module
module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Global history register
reg [6:0] global_history;

// Pattern history table (PHT)
reg [1:0] pht [127:0];

// Calculate index
wire [6:0] index = predict_pc ^ global_history;

// Training index
reg [6:0] train_index;

// Update global history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], pht[index][1]};
    end
end

// Make prediction
always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (pht[index][1] == 1'b1); // Check MSB for taken
        predict_history <= global_history;
    end
end

// Update PHT
always @(posedge clk) begin
    if (train_valid) begin
        train_index = train_pc ^ train_history;
        if (train_index < 128) begin
            if (train_taken) begin
                pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
            end else begin
                pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
            end
        end
    end
end

// Initialize PHT
integer i;
initial begin
    for (i = 0; i < 128; i++) begin
        pht[i] = 2'b01; // Initialize to weakly taken state
    end
end

endmodule