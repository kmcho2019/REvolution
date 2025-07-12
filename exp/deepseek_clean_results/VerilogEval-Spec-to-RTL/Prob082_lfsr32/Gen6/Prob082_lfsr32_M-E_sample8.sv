module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Parallel feedback computation combining all taps
wire feedback = q[0] ^ q[30] ^ q[20] ^ q[1];

always @(posedge clk) begin
    q <= reset ? 32'h1 : {feedback, q[31:1]};
end

endmodule