module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a)
        q <= 3'b100;      // Load 4 when a=1
    else begin
        if (q == 3'b110)  // If q == 6
            q <= 3'b000;  // Wrap to 0
        else
            q <= q + 1;   // Increment q
    end
end

endmodule