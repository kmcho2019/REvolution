module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // No carry yet (waiting for first '1')
    localparam S1 = 1'b1; // Carry started, invert bits

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (x) begin
                        state <= S1;
                        z <= 1'b1;       // First '1' bit passed through
                    end else begin
                        state <= S0;
                        z <= 1'b0;       // Still waiting for first '1'
                    end
                end
                S1: begin
                    state <= S1;
                    z <= ~x;             // Invert subsequent bits
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule