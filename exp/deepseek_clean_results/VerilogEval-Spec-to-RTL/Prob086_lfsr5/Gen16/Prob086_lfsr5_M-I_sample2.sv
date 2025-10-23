module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

parameter RST_VAL = 5'b00001;
wire feedback = q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= RST_VAL;
    end
    else begin
        q[4] <= feedback;
        q[3] <= q[4];
        q[2] <= q[3] ^ feedback;  // Tap at position 3 (q[2])
        q[1] <= q[2];
        q[0] <= q[1];             // Tap at position 5 (q[4])
    end
end

endmodule