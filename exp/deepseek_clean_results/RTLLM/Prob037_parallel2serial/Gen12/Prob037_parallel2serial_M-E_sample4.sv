module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg state;  // 0: LOAD, 1: SHIFT

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= 0;
            valid_out <= 0;
            dout <= 0;
        end else begin
            case (state)
                0: begin  // LOAD state
                    shift_reg <= d;
                    dout <= d[3];
                    valid_out <= 1;
                    state <= 1;
                end
                1: begin  // SHIFT state
                    // Circular shift left with feedback
                    shift_reg <= {shift_reg[2:0], shift_reg[3]};
                    dout <= shift_reg[2];
                    valid_out <= 0;
                    if (&shift_reg[1:0]) state <= 0;  // Return to LOAD after 3 shifts
                end
            endcase
        end
    end

endmodule