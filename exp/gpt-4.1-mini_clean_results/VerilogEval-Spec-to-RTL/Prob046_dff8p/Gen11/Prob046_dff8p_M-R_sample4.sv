module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    // Synchronous reset value
    localparam [7:0] RESET_VAL = 8'h34;

    // Negative edge triggered DFF with synchronous reset
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule