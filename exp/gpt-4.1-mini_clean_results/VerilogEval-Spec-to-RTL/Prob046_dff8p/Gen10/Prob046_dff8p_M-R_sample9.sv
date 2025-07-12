module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    localparam [7:0] RESET_VAL = 8'h34;

    // Negative edge triggered 8-bit DFFs with synchronous reset
    always @(negedge clk) begin
        if (reset) begin
            q <= RESET_VAL;
        end else begin
            q <= d;
        end
    end
endmodule