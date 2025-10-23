module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding with localparam for clarity
    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Combined state transition and register logic
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

    // Moore output depends only on state
    assign out = state;

endmodule