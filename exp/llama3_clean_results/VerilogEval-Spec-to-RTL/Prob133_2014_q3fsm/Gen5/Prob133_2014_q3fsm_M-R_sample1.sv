module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state; // State A = 0, State B = 1
reg [2:0] w_shift_reg; // Shift register for w values
wire z_comb; // Combinational output for z

// Combinational logic for z
assign z_comb = (w_shift_reg == 3'b001) || (w_shift_reg == 3'b010) || (w_shift_reg == 3'b100);

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_shift_reg <= 0;
    end else begin
        if(state == 0) begin // State A
            if(s) begin
                state <= 1; // Transition to state B
            end
        end else begin // State B
            // Shift in the new w value
            w_shift_reg <= {w, w_shift_reg[2:1]};
        end
    end
end

// Output z based on combinational logic
assign z = (state == 1) ? z_comb : 0;

endmodule