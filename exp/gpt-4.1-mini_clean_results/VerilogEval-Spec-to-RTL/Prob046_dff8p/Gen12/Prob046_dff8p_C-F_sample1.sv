module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    localparam [7:0] RESET_VECTOR = 8'h34;

    always @(negedge clk) begin
        if (reset)
            q <= RESET_VECTOR;
        else
            q <= d;
    end
endmodule