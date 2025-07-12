module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [5:0] state; // 6-bit one-hot encoded state register

// Next state logic
always @ (posedge clk) begin
    if (reset) begin
        state <= 6'b000001; // Reset to state A
    end else begin
        case (1'b1)
            state[0]: state <= w? 6'b000010 : state; // State A
            state[1]: state <= w? 6'b000100 : 6'b001000; // State B
            state[2]: state <= w? 6'b010000 : 6'b001000; // State C
            state[3]: state <= w? 6'b100000 : 6'b000001; // State D
            state[4]: state <= w? state : 6'b001000; // State E
            state[5]: state <= w? 6'b000100 : 6'b001000; // State F
            default: state <= 6'b000001; // Default to state A
        endcase
    end
end

// Output z
assign z = state[4] || state[5]; // z is high when state is E or F

endmodule