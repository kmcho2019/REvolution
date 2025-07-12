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
        if (q == 4'b1001)  // if count reaches 9
            q <= 4'b0000;  // wrap around to 0
        else
            q <= q + 1;     // otherwise increment
    end
end

endmodule