module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] xor_mask;
wire [31:0] next_q;

// Create XOR mask: bits at tap positions get q[0], others get 0
assign xor_mask = {32{q[0]}} & 32'h80000003;

// Next state computation: shift right and apply XOR mask
assign next_q = {q[0], q[31:1]} ^ xor_mask;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule