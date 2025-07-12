module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // On rising edge of clk:
    // If reset is high, synchronously clear q to zero.
    // Else, capture input d.
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule