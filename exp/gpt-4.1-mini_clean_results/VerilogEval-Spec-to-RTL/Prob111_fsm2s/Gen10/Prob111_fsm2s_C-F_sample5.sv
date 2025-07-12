module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            case(state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
    end

    // Moore output registered synchronously from the current state to improve timing and glitch immunity
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (state == ON);
    end

endmodule