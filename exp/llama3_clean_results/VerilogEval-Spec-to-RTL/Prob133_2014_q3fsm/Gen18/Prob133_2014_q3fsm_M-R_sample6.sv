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
reg [2:0] prev_w_shift_reg; // Previous value of w_shift_reg
reg ones_count; // Counter to track the number of '1's in the last three 'w' values

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        w_shift_reg <= 3'b000;
        prev_w_shift_reg <= 3'b000;
        ones_count <= 1'b0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    w_shift_reg <= {w, 2'b00};
                    prev_w_shift_reg <= 3'b000;
                    ones_count <= w;
                end
                z <= 0;
            end
            STATE_B: begin
                prev_w_shift_reg <= w_shift_reg;
                w_shift_reg <= {w, w_shift_reg[2:1]};
                // Count the number of '1's in the last three 'w' values
                ones_count <= (w_shift_reg[2] ? 1'b1 : 1'b0) + (w_shift_reg[1] ? 1'b1 : 1'b0) + (w ? 1'b1 : 1'b0);
                // Check if we have reached the end of the three clock cycles
                if(prev_w_shift_reg == 3'b111 || prev_w_shift_reg == 3'b000) begin
                    // Check if exactly two of the last three 'w' values are '1'
                    if(ones_count == 3'b010 || ones_count == 3'b101 || ones_count == 3'b110) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule