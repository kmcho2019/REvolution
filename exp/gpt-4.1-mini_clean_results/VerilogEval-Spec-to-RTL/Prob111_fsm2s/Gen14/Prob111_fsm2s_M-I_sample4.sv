module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // State update with integrated next state logic (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
                default: state <= OFF; // Defensive coding
            endcase
        end
    end

    // Moore output
    assign out = (state == ON);

endmodule