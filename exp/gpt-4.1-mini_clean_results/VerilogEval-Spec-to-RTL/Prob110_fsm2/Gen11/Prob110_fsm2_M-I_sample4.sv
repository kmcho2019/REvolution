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

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else begin
            case(state)
                OFF: state <= (j) ? ON : OFF;
                ON : state <= (k) ? OFF : ON;
                default: state <= OFF; // safe default
            endcase
        end
    end

    assign out = (state == ON);

endmodule