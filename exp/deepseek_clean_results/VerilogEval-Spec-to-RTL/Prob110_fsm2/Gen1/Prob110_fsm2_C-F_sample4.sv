module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding (0=OFF, 1=ON)
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state;

    // Combined state transition and register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end

    // Output logic (pure Moore)
    assign out = state;

endmodule