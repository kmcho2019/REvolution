module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2] ^ q[4];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {q[3:0], feedback};
end

endmodule