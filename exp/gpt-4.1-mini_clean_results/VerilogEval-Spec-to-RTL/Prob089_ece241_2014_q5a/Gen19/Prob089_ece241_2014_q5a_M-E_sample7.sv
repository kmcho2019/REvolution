module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    // 0: waiting for first '1'
    // 1: first '1' detected, invert subsequent bits
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    z <= x;          // output input bit directly before first '1'
                    if (x == 1'b1)   // transition to state 1 on first '1'
                        state <= 1'b1;
                end
                1'b1: begin
                    z <= ~x;         // invert input bits after first '1'
                    // remain in state 1
                end
            endcase
        end
    end

endmodule