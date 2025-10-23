module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state;
    localparam OFF = 1'b0, ON = 1'b1;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
    end

    always @(*) begin
        out = (state == ON);
    end

endmodule