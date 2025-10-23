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
reg [1:0] counter; // Counter to track the number of clock cycles since entering state B
reg [1:0] ones; // Counter to track the number of '1's in the last three 'w' values

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        w_shift_reg <= 3'b000;
        counter <= 2'b00;
        ones <= 2'b00;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    counter <= 2'b01;
                    w_shift_reg <= {w, 2'b00};
                    ones <= w ? 1 : 0;
                end
                z <= 0;
            end
            STATE_B: begin
                // Shift in the current value of 'w'
                w_shift_reg <= {w, w_shift_reg[2:1]};
                // Update the ones count
                ones <= (w_shift_reg[2] ? 1 : 0) + (w_shift_reg[1] ? 1 : 0) + (w ? 1 : 0);
                // Increment the counter
                counter <= counter + 1'b1;
                // Check if we have reached the end of the three clock cycles
                if(counter == 2'b11) begin
                    // Check if exactly two of the last three 'w' values are '1'
                    if(ones == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    // Reset the counter and ones count
                    counter <= 2'b01;
                    ones <= w ? 1 : 0;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule