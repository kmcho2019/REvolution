module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding (one-hot style)
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Asynchronous active-high reset state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
                default: state <= OFF;
            endcase
        end
    end

    // Moore output: output depends only on current state
    assign out = (state == ON);

endmodule