module TopModule #(
    parameter WIDTH = 4
)(
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output reg  [WIDTH-1:0] q
);

wire [WIDTH-1:0] next_q;
wire [WIDTH:0] carry; // carry chain, 1 bit wider than counter width

assign carry[0] = 1'b1; // initial carry-in is 1 for increment by 1

// Generate block to create ripple carry increment logic:
// next_q[i] = q[i] XOR carry[i]
// carry[i+1] = q[i] AND carry[i]
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : ripple_increment
        assign next_q[i] = q[i] ^ carry[i];
        assign carry[i+1] = q[i] & carry[i];
    end
endgenerate

always @(posedge clk) begin
    if (reset)
        q <= {WIDTH{1'b0}};
    else
        q <= next_q;
end

endmodule