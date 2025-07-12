module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Parameterized tap positions (32,22,2,1)
localparam TAP_MASK = 32'b10000000001000000000000000000011;

wire feedback;
wire [31:0] next_q;

// Combinational feedback calculation
assign feedback = q[0];

// Next state calculation using mask and circular shift
assign next_q = reset ? 32'h1 : 
               {feedback, q[31:1]} ^ (TAP_MASK & {32{feedback}});

// Sequential update
always @(posedge clk) begin
    q <= next_q;
end

endmodule