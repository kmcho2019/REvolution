module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire tap31 = q[31];
wire tap21 = q[21];
wire tap1 = q[1];
wire tap0 = q[0];

wire feedback = tap31 ^ tap21 ^ tap1 ^ tap0;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {feedback, q[31:1]};
    end
end

endmodule