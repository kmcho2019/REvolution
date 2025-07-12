module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state;  // 0: B (out=1), 1: A (out=0)

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // B
            out <= 1;
        end else begin
            case(state)
                0: begin
                    // B: out=1
                    if (in == 0)
                        state <= 1; // A
                    else
                        state <= 0; // B
                    out <= 1;
                end
                1: begin
                    // A: out=0
                    if (in == 0)
                        state <= 0; // B
                    else
                        state <= 1; // A
                    out <= 0;
                end
            endcase
        end
    end

endmodule