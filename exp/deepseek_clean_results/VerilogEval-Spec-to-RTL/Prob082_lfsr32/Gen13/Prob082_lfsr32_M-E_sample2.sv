module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] xor_mask;
wire [31:0] next_q;

// Create XOR mask (1 at tap positions)
assign xor_mask = {32'b1, 31'b0} | {10'b0, 1'b1, 21'b0} | {30'b0, 2'b11};

// Parallel XOR computation for all bits
assign next_q = (q ^ {32{q[0]}}) & xor_mask;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Combine the XOR results with the shifted value
        q <= {q[0], q[31:1]} ^ next_q;
    end
end

endmodule