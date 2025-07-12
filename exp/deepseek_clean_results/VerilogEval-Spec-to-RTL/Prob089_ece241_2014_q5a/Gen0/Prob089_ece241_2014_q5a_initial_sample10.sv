module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define states
    parameter STATE_INIT = 1'b0;
    parameter STATE_COMPLEMENT = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_INIT;
        end else begin
            case (state)
                STATE_INIT: 
                    if (x) state <= STATE_COMPLEMENT;
                STATE_COMPLEMENT: 
                    state <= STATE_COMPLEMENT;
            endcase
        end
    end

    // Moore machine: output depends only on state
    always @(*) begin
        case (state)
            STATE_INIT: z = x;
            STATE_COMPLEMENT: z = ~x;
        endcase
    end

endmodule