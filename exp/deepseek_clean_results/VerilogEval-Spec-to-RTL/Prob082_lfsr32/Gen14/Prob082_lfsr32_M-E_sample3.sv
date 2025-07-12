module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback;
wire [3:0] tap_bits;

// Extract tap bits
assign tap_bits = {q[31], q[22], q[2], q[1]};

// Parallel XOR reduction for feedback
assign feedback = ^(tap_bits & {4{q[0]}});

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Shift right and apply feedback to tap positions
        q <= {q[0], q[31:23], 
              q[22] ^ (feedback & q[0]), 
              q[21:3], 
              q[2] ^ (feedback & q[0]), 
              q[1] ^ (feedback & q[0])};
    end
end

endmodule