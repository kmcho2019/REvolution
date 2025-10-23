module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 2'b00;
localparam STATE_B1 = 2'b01;
localparam STATE_B2 = 2'b10;
localparam STATE_B3 = 2'b11;

reg [1:0] state; // Current state
reg [2:0] w_shift_reg; // Shift register to store last three values of 'w'
reg z_next; // Next value of 'z'

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
                    state <= STATE_B1;
                end
                z <= 0;
            end
            STATE_B1: begin
                // Shift in the current value of 'w'
                w_shift_reg <= {w, w_shift_reg[2:1]};
                state <= STATE_B2;
                z <= 0;
            end
            STATE_B2: begin
                // Shift in the current value of 'w'
                w_shift_reg <= {w, w_shift_reg[2:1]};
                state <= STATE_B3;
                z <= 0;
            end
            STATE_B3: begin
                // Shift in the current value of 'w'
                w_shift_reg <= {w, w_shift_reg[2:1]};
                // Check if exactly two of the last three 'w' values are '1'
                if(w_shift_reg == 3'b110 || w_shift_reg == 3'b101 || w_shift_reg == 3'b011) begin
                    z_next <= 1;
                end
                else begin
                    z_next <= 0;
                end
                state <= STATE_B1; // Transition back to STATE_B1
            end
        endcase
        // Update 'z' with 'z_next'
        z <= z_next;
    end
end

endmodule