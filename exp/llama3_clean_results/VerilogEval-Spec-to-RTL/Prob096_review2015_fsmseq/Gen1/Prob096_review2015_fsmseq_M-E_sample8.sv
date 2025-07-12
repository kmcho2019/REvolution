module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000;
        start_shifting <= 0;
    end else begin
        // Shift the register and add the new bit
        shift_register <= {shift_register[2:0], data};
        
        // Check if the sequence 1101 has been found
        if (shift_register == 4'b1101) begin
            start_shifting <= 1;
        end
    end
end

endmodule