module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam NO_CARRY       = 1'b0;
    localparam CARRY_PROCESSED = 1'b1;

    reg state;
    reg x_d;  // registered input delayed by one clock

    // State and input register update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= NO_CARRY;
            x_d <= 1'b0;
            z <= 1'b0;
        end else begin
            x_d <= x;
            case (state)
                NO_CARRY: begin
                    if (x_d == 1'b1)
                        state <= CARRY_PROCESSED;
                    else
                        state <= NO_CARRY;
                end
                CARRY_PROCESSED: begin
                    state <= CARRY_PROCESSED;
                end
            endcase

            // Moore output depends on state and registered x_d
            case (state)
                NO_CARRY:       z <= x_d;
                CARRY_PROCESSED: z <= ~x_d;
                default:        z <= 1'b0;
            endcase
        end
    end

endmodule