module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // State register with asynchronous reset and combined next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else begin
            case(state)
                OFF: state <= j ? ON : OFF;
                ON : state <= k ? OFF : ON;
                default: state <= OFF;
            endcase
        end
    end

    // Output logic
    assign out = state;

endmodule