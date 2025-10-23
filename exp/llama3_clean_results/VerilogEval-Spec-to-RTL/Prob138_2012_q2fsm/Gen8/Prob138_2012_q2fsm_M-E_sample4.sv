module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] counter; // 3-bit counter to represent states

// Counter-based state machine
always @ (posedge clk) begin
    if (reset) begin
        counter <= 3'b000; // Reset to state A
    end else begin
        case (counter)
            3'b000: // State A
                counter <= w ? 3'b001 : 3'b000;
            3'b001: // State B
                counter <= w ? 3'b010 : 3'b011;
            3'b010: // State C
                counter <= w ? 3'b100 : 3'b011;
            3'b011: // State D
                counter <= w ? 3'b101 : 3'b000;
            3'b100: // State E
                counter <= w ? 3'b100 : 3'b011;
            3'b101: // State F
                counter <= w ? 3'b010 : 3'b011;
            default:
                counter <= 3'b000; // Default to state A
        endcase
    end
end

// Output z
assign z = (counter[2] == 1'b1); // z is high when state is E or F

endmodule