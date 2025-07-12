module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state; // 3-bit state register

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        case (state)
            3'b000: // State A
                state <= w? 3'b001 : 3'b000;
            3'b001: // State B
                state <= w? 3'b010 : 3'b011;
            3'b010: // State C
                state <= w? 3'b100 : 3'b011;
            3'b011: // State D
                state <= w? 3'b101 : 3'b000;
            3'b100: // State E
                state <= w? 3'b100 : 3'b011;
            3'b101: // State F
                state <= w? 3'b010 : 3'b011;
            default:
                state <= 3'b000; // Default to state A
        endcase
    end
end

// Output z
assign z = (state == 3'b100 || state == 3'b101); // z is high when state is E or F

endmodule