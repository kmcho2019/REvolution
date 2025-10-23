module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0]   q
);
    localparam [7:0] RESET_VAL = 8'h34;

    // Negative edge triggered 8-bit DFFs with synchronous active-high reset
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule