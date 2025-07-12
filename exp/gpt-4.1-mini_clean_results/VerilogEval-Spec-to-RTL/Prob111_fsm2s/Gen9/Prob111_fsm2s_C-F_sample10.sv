module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= (state == OFF) ? (j ? ON : OFF)
                                    : (k ? OFF : ON);
            out <= (state == ON);
        end
    end

endmodule