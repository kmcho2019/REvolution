module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Create a mask for the tap positions
wire [31:0] tap_mask = {1'b1, 9'b0, 1'b1, 20'b0, 2'b11};

// Parallel XOR of all tapped bits with q[0]
wire feedback;
assign feedback = ^(q & tap_mask) ^ q[0];

// Next state calculation
wire [31:0] next_q;
assign next_q = reset ? 32'h1 : 
                {q[0], q[31:1] ^ ({31{feedback}} & tap_mask[30:0])};

always @(posedge clk) begin
    q <= next_q;
end

endmodule