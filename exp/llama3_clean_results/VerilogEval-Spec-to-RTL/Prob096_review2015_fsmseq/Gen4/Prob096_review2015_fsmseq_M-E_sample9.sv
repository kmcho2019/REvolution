module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_register; // 4-bit shift register

// Shift register logic
always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // Reset the shift register
        start_shifting <= 0;
    end else begin
        shift_register <= {data, shift_register[3:1]}; // Shift in the new data
        if (shift_register == 4'b1101) begin
            start_shifting <= 1; // Set start_shifting to 1 when the sequence is found
        end else if (reset) begin
            start_shifting <= 0; // Reset start_shifting when reset is asserted
        end
    end
end

endmodule