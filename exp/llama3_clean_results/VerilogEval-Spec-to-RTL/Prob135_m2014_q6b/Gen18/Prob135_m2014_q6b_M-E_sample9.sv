module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Define the next state logic for y[1] using a lookup table (LUT) approach
    reg [1:0] next_y1;

    // The LUT contents are derived from the state machine's transition table
    // Each entry corresponds to the next value of y[1] based on the current state (y) and input (w)
    always @(*) begin
        case (y)
            3'b000: next_y1 = (~w)? 2'b01 : 2'b00; // State A transitions
            3'b001: next_y1 = (~w)? 2'b01 : 2'b01; // State B transitions
            3'b010: next_y1 = (~w)? 2'b01 : 2'b01; // State C transitions
            3'b011: next_y1 = (~w)? 2'b01 : 2'b00; // State D transitions
            3'b100: next_y1 = (~w)? 2'b01 : 2'b01; // State E transitions
            3'b101: next_y1 = (~w)? 2'b00 : 2'b01; // State F transitions
            default: next_y1 = 2'b00; // Default next state for y[1]
        endcase
    end

    assign Y1 = next_y1[1]; // Assign the computed next state of y[1] to the output

endmodule