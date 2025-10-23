module TopModule (
    input clk,
    input reset,
    input enable,    // Added for power optimization
    output reg [31:0] q
);

wire [31:0] next_q;

// Combinational logic for LFSR (taps at 32,22,2,1)
assign next_q = {q[0], q[31:23], q[22] ^ q[0], q[21:3], q[2] ^ q[0], q[1] ^ q[0]};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else if (enable) begin  // Only update when enabled
        q <= next_q;
    end
end

endmodule