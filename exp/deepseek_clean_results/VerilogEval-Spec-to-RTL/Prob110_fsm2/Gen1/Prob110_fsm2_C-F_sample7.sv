module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding (binary for minimal area)
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state;  // State register

    // State transition logic (combinational + sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;  // Async reset to OFF state
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;  // J=1 moves to ON, else stay
                ON:  state <= k ? OFF : ON;  // K=1 moves to OFF, else stay
            endcase
        end
    end

    // Output logic - pure Moore style (depends only on state)
    assign out = (state == ON);  // ON state drives output high

endmodule