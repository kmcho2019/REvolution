module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end else begin
            case (state)
                STATE_PASS: if (x) state <= STATE_INVERT;
                STATE_INVERT: state <= STATE_INVERT;
            endcase
        end
    end

    // Output logic - combinational
    assign z = (state == STATE_PASS) ? x : ~x;

endmodule