module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define states
    parameter STATE_SEARCH = 1'b0;
    parameter STATE_COMPLEMENT = 1'b1;
    
    reg state;
    reg next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_SEARCH: begin
                next_state = x ? STATE_COMPLEMENT : STATE_SEARCH;
            end
            STATE_COMPLEMENT: begin
                next_state = STATE_COMPLEMENT;
            end
            default: begin
                next_state = STATE_SEARCH;
            end
        endcase
    end

    // Output logic (Moore machine: output depends only on state)
    always @(*) begin
        case (state)
            STATE_SEARCH: begin
                z = x;
            end
            STATE_COMPLEMENT: begin
                z = ~x;
            end
            default: begin
                z = x;
            end
        endcase
    end

endmodule