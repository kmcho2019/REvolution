module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define states
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end else begin
            case (state)
                STATE_PASS: 
                    if (x) state <= STATE_INVERT;
                STATE_INVERT: 
                    state <= STATE_INVERT; // Stay in this state
            endcase
        end
    end

    // Output logic (Moore machine: output depends only on state)
    always @(*) begin
        case (state)
            STATE_PASS: z = x;
            STATE_INVERT: z = ~x;
        endcase
    end

endmodule