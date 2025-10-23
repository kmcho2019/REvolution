module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // FSM States
    localparam WAIT_CARRY = 1'b0; // No carry found yet
    localparam INVERT    = 1'b1; // Carry found, invert bits

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_CARRY;
            z <= 1'b0;
        end else begin
            case(state)
                WAIT_CARRY: begin
                    if (x == 1'b1) begin
                        state <= INVERT;
                        z <= 1'b1;       // Output 1 for the first '1' bit (carry bit)
                    end else begin
                        state <= WAIT_CARRY;
                        z <= 1'b0;       // Output input bit '0' as-is before carry
                    end
                end

                INVERT: begin
                    state <= INVERT;
                    z <= ~x;             // Invert bits after carry
                end
            endcase
        end
    end

endmodule