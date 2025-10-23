module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    // On negative edge of clk, synchronously reset q to 8'h34 or load d
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
        else
            q <= d;
    end
endmodule