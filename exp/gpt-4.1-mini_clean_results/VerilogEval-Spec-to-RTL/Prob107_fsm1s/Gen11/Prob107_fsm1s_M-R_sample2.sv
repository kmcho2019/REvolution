module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    reg next_state;
    reg out_reg;

    // Combinational next-state and output logic using case statement
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
                out_reg = 1'b1;
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
                out_reg = 1'b0;
            end
            default: begin
                next_state = B;
                out_reg = 1'b1;
            end
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output assigned from registered Moore output
    assign out = out_reg;

endmodule