module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j == 1'b1)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if (k == 1'b1)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // Output logic (Moore output depends only on state)
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule