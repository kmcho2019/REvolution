module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding (1-bit)
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state combinational logic simplified
    always @(*) begin
        if (state == OFF)
            next_state = j ? ON : OFF;
        else
            next_state = k ? OFF : ON;
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= (next_state == ON);
        end
    end

endmodule