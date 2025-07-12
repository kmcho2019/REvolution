module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    reg state;

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State register with async reset and next state logic combined
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
                default: state <= OFF;
            endcase
    end

    // Moore output depends only on state
    assign out = (state == ON);

endmodule