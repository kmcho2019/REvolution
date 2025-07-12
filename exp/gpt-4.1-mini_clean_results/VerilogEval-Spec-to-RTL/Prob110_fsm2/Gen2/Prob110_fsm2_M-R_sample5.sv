module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg current_state, next_state;
    reg out_reg;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Next state and output logic combined (Moore FSM)
    always @(*) begin
        case (current_state)
            OFF: begin
                out_reg = 1'b0;
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out_reg = 1'b1;
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: begin
                out_reg = 1'b0;
                next_state = OFF;
            end
        endcase
    end

    // Output driven from registered out_reg
    assign out = out_reg;

endmodule