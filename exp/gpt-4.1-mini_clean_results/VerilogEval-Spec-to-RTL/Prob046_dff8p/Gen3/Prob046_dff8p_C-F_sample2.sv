module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;    // Synchronous reset loads 0x34
        else
            q <= d;        // Otherwise load input d
    end
endmodule