module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        q <= 5'b00001;
    end else begin
        q <= {q[3] ^ q[0], q[2] ^ q[0], q[1], q[0], 1'b0};
    end
end

endmodule