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

    // Combined state and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_SEARCH;
            z <= 1'b0;
        end else begin
            case (state)
                STATE_SEARCH: begin
                    z <= x;
                    if (x) state <= STATE_COMPLEMENT;
                end
                STATE_COMPLEMENT: begin
                    z <= ~x;
                end
                default: begin
                    state <= STATE_SEARCH;
                    z <= x;
                end
            endcase
        end
    end

endmodule