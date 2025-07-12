module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    parameter SEARCH = 1'b0;
    parameter COMPLEMENT = 1'b1;
    
    reg state; // Current state

    // State transition logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= SEARCH;
        end else begin
            case (state)
                SEARCH:     state <= x ? COMPLEMENT : SEARCH;
                COMPLEMENT: state <= COMPLEMENT;
            endcase
        end
    end

    // Output logic (combinational)
    assign z = (state == SEARCH) ? x : ~x;

endmodule