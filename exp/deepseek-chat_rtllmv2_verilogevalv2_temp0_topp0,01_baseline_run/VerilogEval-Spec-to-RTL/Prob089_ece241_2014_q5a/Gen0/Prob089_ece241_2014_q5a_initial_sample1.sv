module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define states
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
            z <= 1'b0;
        end else begin
            case (state)
                STATE_PASS: begin
                    z <= x;
                    if (x) begin
                        state <= STATE_INVERT;
                    end
                end
                STATE_INVERT: begin
                    z <= ~x;
                end
            endcase
        end
    end

endmodule