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
            state <= 1'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            case (state)
                1'b0: begin  // LOAD state
                    shift_reg <= d;
                    dout <= d[3];
                    valid_out <= 1'b1;
                    state <= 1'b1;
                end
                1'b1: begin  // SHIFT state
                    // Circular shift left
                    shift_reg <= {shift_reg[2:0], shift_reg[3]};
                    dout <= shift_reg[2];
                    valid_out <= 1'b0;
                    
                    // After 3 shifts, go back to LOAD
                    if (&shift_reg[1:0]) begin  // Detect when we've done 3 shifts
                        state <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule