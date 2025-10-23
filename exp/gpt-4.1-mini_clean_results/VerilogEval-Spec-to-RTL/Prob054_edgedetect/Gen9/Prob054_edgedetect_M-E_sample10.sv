module TopModule (
    input          clk,
    input   [7:0]  in,
    output reg [7:0] pedge
);

    reg [15:0] shift_reg;  // Holds two consecutive samples of `in`

    always @(posedge clk) begin
        // Shift in the new input sample into the lower half
        shift_reg <= {shift_reg[7:0], in};

        // Detect 0->1 transitions by comparing previous sample (lower 8 bits)
        // to current sample (upper 8 bits) after the shift
        // The current sample is in shift_reg[15:8]
        // The previous sample is in shift_reg[7:0]
        // The output pedge is set one clock cycle later to the detected edges
        pedge <= (~shift_reg[7:0]) & shift_reg[15:8];
    end

endmodule