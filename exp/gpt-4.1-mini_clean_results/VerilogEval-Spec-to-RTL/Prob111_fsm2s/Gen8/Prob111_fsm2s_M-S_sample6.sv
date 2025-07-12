module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state, next_state;
    localparam OFF = 1'b0, ON = 1'b1;

    always @(*) begin
        if (state == OFF) begin
            next_state = j ? ON : OFF;
        end else begin
            next_state = k ? OFF : ON;
        end
    end

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    always @(*) begin
        out = state; // out=0 when OFF, 1 when ON
    end

endmodule