module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial begin
    q = 3'b100;  // Initialize to 4 (simulation only)
end

always @(posedge clk) begin
    if (q === 3'bx) begin  // Handle power-up initialization
        q <= 3'b100;
    end else if (a) begin
        q <= q;  // Hold when a=1
    end else begin
        if (q == 3'b110)  // Wrap around after 6
            q <= 3'b000;
        else
            q <= q + 1;  // Increment when a=0
    end
end

endmodule