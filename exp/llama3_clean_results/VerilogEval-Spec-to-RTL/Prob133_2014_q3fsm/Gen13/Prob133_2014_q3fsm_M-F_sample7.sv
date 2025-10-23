module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable to track current state (A or B)
reg [2:0] w_shift_reg; // 3-bit shift register to track 'w' occurrences
reg [2:0] w_count; // Counter to track 'w' occurrences in the shift register

// Sequential logic for state, shift register, and counter
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to A
        w_shift_reg <= 3'b000;
        w_count <= 3'b000;
        z <= 1'b0; // Reset output z
    end else begin
        case(state)
            2'b00: // State A
                begin
                    if(s) begin
                        state <= 2'b01; // Transition to state B
                        w_shift_reg <= {w, 2'b00};
                        w_count <= {w, 2'b00};
                    end else begin
                        state <= 2'b00; // Remain in state A
                        w_shift_reg <= 3'b000;
                        w_count <= 3'b000;
                    end
                end
            2'b01: // State B
                begin
                    w_shift_reg <= {w, w_shift_reg[1:0]}; // Shift 'w' into the register
                    w_count <= {w ? 1'b1 : 1'b0, w_shift_reg[1:0]};
                    if(w_shift_reg[2] == 1'b1) begin // Evaluate output 'z' after 3 clock cycles
                        if(w_count == 3'b110 || w_count == 3'b101 || w_count == 3'b011) begin
                            z <= 1'b1; // Set 'z' high if 'w' occurred exactly twice in the previous window
                        end else begin
                            z <= 1'b0;
                        end
                        state <= 2'b01; // Remain in state B
                        w_shift_reg <= {w, 2'b00};
                        w_count <= {w, 2'b00};
                    end else begin
                        z <= 1'b0;
                    end
                end
            default: ;
        endcase
    end
end

endmodule