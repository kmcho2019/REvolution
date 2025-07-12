module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    parameter PASS = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            case (state)
                PASS:    state <= x ? INVERT : PASS;
                INVERT:  state <= INVERT;
            endcase
        end
    end
    
    // Output logic - pure Moore machine
    assign z = (state == PASS) ? x : ~x;

endmodule