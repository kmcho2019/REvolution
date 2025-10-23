module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg state, next_state;

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state and output logic combined
    always @(*) begin
        case (state)
            OFF: begin
                next_state = (j) ? ON : OFF;
                out = 1'b0;
            end
            ON: begin
                next_state = (k) ? OFF : ON;
                out = 1'b1;
            end
            default: begin
                next_state = OFF;
                out = 1'b0;
            end
        endcase
    end

endmodule