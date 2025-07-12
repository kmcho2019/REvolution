module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] counter; // 3-bit counter to represent states

// Reset
always @ (posedge clk) begin
    if (reset) begin
        counter <= 3'b000; // Reset to state A
    end
end

// Counter-based state machine
always @ (posedge clk) begin
    if (!reset) begin
        case (counter)
            3'b000: counter <= w ? 3'b001 : counter; // State A
            3'b001: counter <= w ? 3'b010 : 3'b011; // State B
            3'b010: counter <= w ? 3'b100 : 3'b011; // State C
            3'b011: counter <= w ? 3'b101 : 3'b000; // State D
            3'b100: counter <= w ? counter : 3'b011; // State E
            3'b101: counter <= w ? 3'b010 : 3'b011; // State F
            default: counter <= 3'b000; // Default to state A
        endcase
    end
end

// However, this can be simplified further. Here is the simplified version:
// Counter-based state machine
always @ (posedge clk) begin
    if (!reset) begin
        if (counter == 3'b000) counter <= w ? 3'b001 : counter;
        else if (counter == 3'b001) counter <= w ? 3'b010 : 3'b011;
        else if (counter == 3'b010) counter <= w ? 3'b100 : 3'b011;
        else if (counter == 3'b011) counter <= w ? 3'b101 : 3'b000;
        else if (counter == 3'b100) counter <= w ? counter : 3'b011;
        else if (counter == 3'b101) counter <= w ? 3'b010 : 3'b011;
        else counter <= 3'b000;
    end
end

// Output z
assign z = (counter >= 3'b100); // z is high when state is E or F

endmodule