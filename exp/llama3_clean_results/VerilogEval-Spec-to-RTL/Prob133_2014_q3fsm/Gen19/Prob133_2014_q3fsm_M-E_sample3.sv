module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] w_shift_reg; // Shift register to store 'w' values
reg state; // Current state (0 for A, 1 for B)

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_shift_reg <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    w_shift_reg <= {w, 2'b00}; // Initialize shift register
                end
                else begin
                    z <= 0;
                end
            end
            1: begin // State B
                {w_shift_reg[1:0], w_shift_reg[2]} <= {w_shift_reg[1:0], w}; // Shift 'w' values
                if(w_shift_reg[2] == 1'b1) begin // Check if the third 'w' value is 1
                    if((w_shift_reg[1:0] == 2'b01) || (w_shift_reg[1:0] == 2'b10)) begin
                        z <= 1'b1; // Set 'z' to 1 if exactly two '1's in 'w' values
                    end
                    else begin
                        z <= 1'b0; // Set 'z' to 0 otherwise
                    end
                end
                else begin
                    z <= 1'b0;
                end
            end
        endcase
    end
end

endmodule