module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0, ON = 1'b1;
    reg state;
    wire next_state;

    assign next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_state;
        end
    end

endmodule