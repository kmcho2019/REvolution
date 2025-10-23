module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding: OFF=0, ON=1 (1-bit state)
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state and output logic (Moore): combinational always block
    always @(*) begin
        case (state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
                out = 1'b0;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
                out = 1'b1;
            end
            default: begin
                next_state = OFF;
                out = 1'b0;
            end
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule