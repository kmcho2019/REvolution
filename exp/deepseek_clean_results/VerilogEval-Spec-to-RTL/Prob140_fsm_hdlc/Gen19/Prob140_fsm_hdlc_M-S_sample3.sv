module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state;
    reg err_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b0;
            err_reg <= 1'b0;
        end else begin
            if (state == 3'd5) begin
                // Stay in error state until reset
                err_reg <= 1'b1;
            end else if (in) begin
                if (state < 3'd5)
                    state <= state + 1;
            end else begin
                state <= 3'b0;
            end
        end
    end

    assign disc = (state == 3'd5 && !in) ? 1'b1 : 1'b0;
    assign flag = (state == 3'd6 && !in) ? 1'b1 : 1'b0;
    assign err = (state == 3'd5) ? 1'b1 : err_reg;

endmodule