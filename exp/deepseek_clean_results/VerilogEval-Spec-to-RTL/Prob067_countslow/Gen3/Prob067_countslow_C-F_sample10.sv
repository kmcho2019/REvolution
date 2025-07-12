module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        if (q[3] & q[0]) begin  // Efficient detection of 9 (1001)
            q <= 4'b0000;
        end
        else begin
            q <= q + 4'b0001;
        end
    end
end

endmodule