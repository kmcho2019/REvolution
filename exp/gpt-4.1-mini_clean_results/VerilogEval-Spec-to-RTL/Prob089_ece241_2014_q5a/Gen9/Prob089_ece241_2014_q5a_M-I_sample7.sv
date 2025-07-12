module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding:
    // 0 = COPY (no inversion yet)
    // 1 = INVERT (invert subsequent bits)
    reg state;

    always @(posedge clk) begin
        if (areset) begin
            state <= 1'b0;  // COPY state at reset
            z <= 1'b0;
        end else begin
            case(state)
                1'b0: begin
                    z <= x;               // copy input until first '1'
                    state <= (x == 1'b1) ? 1'b1 : 1'b0;
                end
                1'b1: begin
                    z <= ~x;              // invert input bits after first '1'
                    state <= 1'b1;        // remain in invert state
                end
            endcase
        end
    end

endmodule