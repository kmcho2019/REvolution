module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

integer i;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q[0] <= q[1];
        for (i = 1; i < 5; i = i + 1) begin
            if (i == 2 || i == 4) // taps at bit 3 and 5 (indexes 2 and 4)
                q[i] <= q[i+1-5] ^ q[0]; // wrap-around q[5] -> q[0]
            else
                q[i] <= q[i+1-5];
        end
    end
end

endmodule