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

// Pattern History Table (PHT) with 128 entries of 2-bit saturating counters
reg [1:0] pht [127:0];

// Global Branch History Register
reg [6:0] gbr;

// Index calculation using XOR
wire [6:0] index = (predict_pc ^ gbr);

// Predicted branch direction
wire predict_taken_int = (pht[index] >= 2'b10);

// Update global branch history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbr <= 7'b0;
    end else if (predict_valid) begin
        gbr <= {gbr[5:0], predict_taken_int};
    end else if (train_valid && train_mispredicted) begin
        gbr <= train_history;
    end
end

// Update pattern history table
always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[{train_pc[6:0] ^ train_history}] == 2'b11) begin
                // Do nothing if counter is already at maximum
            end else begin
                pht[{train_pc[6:0] ^ train_history}] <= pht[{train_pc[6:0] ^ train_history}] + 2'b01;
            end
        end else begin
            if (pht[{train_pc[6:0] ^ train_history}] == 2'b00) begin
                // Do nothing if counter is already at minimum
            end else begin
                pht[{train_pc[6:0] ^ train_history}] <= pht[{train_pc[6:0] ^ train_history}] - 2'b01;
            end
        end
    end
end

// Assign outputs
assign predict_taken = predict_taken_int;
assign predict_history = gbr;

endmodule