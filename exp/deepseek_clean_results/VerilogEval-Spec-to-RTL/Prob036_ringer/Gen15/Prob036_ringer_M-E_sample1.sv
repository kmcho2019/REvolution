module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Combine outputs into a vector for compact representation
    wire [1:0] outputs;
    assign {ringer, motor} = outputs;

    // State-to-output mapping
    always @(*) begin
        case ({ring, vibrate_mode})
            2'b00: outputs = 2'b00;  // No ring, any mode -> both off
            2'b01: outputs = 2'b00;  // No ring, vibrate mode -> both off
            2'b10: outputs = 2'b10;  // Ring, normal mode -> ringer on
            2'b11: outputs = 2'b01;  // Ring, vibrate mode -> motor on
            default: outputs = 2'b00;
        endcase
    end

endmodule