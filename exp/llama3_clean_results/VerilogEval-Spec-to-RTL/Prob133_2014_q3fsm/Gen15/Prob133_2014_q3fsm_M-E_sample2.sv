module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

reg state; // Current state
reg [2:0] w_shift_reg; // Shift register to store last three values of 'w'

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        w_shift_reg <= 3'b000;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                end
                z <= 0;
            end
            STATE_B: begin
                // Shift in the current value of 'w'
                w_shift_reg <= {w, w_shift_reg[2:1]};
                // Check if exactly two of the last three 'w' values are '1'
                if(w_shift_reg == 3'b110 || w_shift_reg == 3'b101 || w_shift_reg == 3'b011) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule