module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [1:0] state; // 2-bit state register

// State machine
always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case (state)
            2'b00: state <= w ? 2'b01 : state; // State A
            2'b01: state <= w ? 2'b10 : 2'b11; // State B
            2'b10: state <= w ? 2'b10 : 2'b11; // State C ( merged with E)
            2'b11: state <= w ? 2'b10 : 2'b00; // State D (merged with F)
            default: state <= 2'b00; // Default to state A
        endcase
    end
end

// Output z
assign z = (state == 2'b10); // z is high when state is C (or E) 

endmodule