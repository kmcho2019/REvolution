module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] shift_reg;
    reg found;
    wire enable_shift = !found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b0;
            found <= 1'b0;
        end else if (enable_shift) begin
            shift_reg <= {shift_reg[0], data};
            // Detect sequence 1101 (shift_reg has bits 2&3, current data is bit 1)
            found <= (shift_reg == 2'b11) && (data == 1'b0) ? 1'b0 :  // Not part of sequence
                    (shift_reg == 2'b10) && (data == 1'b1) ? 1'b1 :   // 101 sequence
                    (shift_reg == 2'b11) && (data == 1'b1) ? 1'b1 :   // 111 sequence (partial match)
                    found;                                           // Maintain state
        end
    end

    assign start_shifting = found;

endmodule