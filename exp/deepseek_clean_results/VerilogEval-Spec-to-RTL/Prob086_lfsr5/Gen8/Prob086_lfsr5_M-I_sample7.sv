module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[3] ^ q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= {q[0], q[4], feedback, q[2], q[1]};
    end
end

endmodule