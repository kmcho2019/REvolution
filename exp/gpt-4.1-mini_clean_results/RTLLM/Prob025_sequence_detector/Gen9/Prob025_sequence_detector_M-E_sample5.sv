module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // 4-bit shift register holding last 4 bits of data_in
    reg [3:0] shift_reg;

    // Asynchronous reset and shifting logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], data_in};
    end

    // Compare shift_reg with the target sequence 1001 (binary)
    assign sequence_detected = (shift_reg == 4'b1001);

endmodule