module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions:
    // 0 = COPY (pass through bits until first '1')
    // 1 = INVERT (invert all subsequent bits)
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin  // COPY state
                    z <= x;
                    if (x) state <= 1;
                end
                1: begin  // INVERT state
                    z <= ~x;
                end
            endcase
        end
    end

endmodule