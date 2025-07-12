module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // State A = 0, State B = 1
reg [2:0] w_shift_reg; // Shift register for w values

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_shift_reg <= 0;
        z <= 0;
    end else begin
        if(state == 0) begin // State A
            if(s) begin
                state <= 1; // Transition to state B
            end
        end else begin // State B
            // Shift in the new w value
            w_shift_reg <= {w, w_shift_reg[2:1]};
            // Check if exactly two w values in the window are 1
            if(w_shift_reg == 3'b001 || w_shift_reg == 3'b010 || w_shift_reg == 3'b100) begin
                z <= 1;
            end else begin
                z <= 0;
            end
        end
    end
end

endmodule