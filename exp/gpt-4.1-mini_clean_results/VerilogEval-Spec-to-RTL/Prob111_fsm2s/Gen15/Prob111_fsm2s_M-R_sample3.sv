module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state and output logic combinational block (Moore output)
    always @(*) begin
        case (state)
            OFF: begin
                out = 1'b0;
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out = 1'b1;
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: begin
                out = 1'b0;
                next_state = OFF;
            end
        endcase
    end

endmodule