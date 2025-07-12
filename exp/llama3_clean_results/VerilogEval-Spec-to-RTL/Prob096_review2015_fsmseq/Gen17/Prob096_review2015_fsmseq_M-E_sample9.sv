module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define a 4-bit shift register
reg [3:0] shift_register;

// Initialize the shift register
initial shift_register = 4'b0000;

// Synchronous reset and shift register update
always @(posedge clk) begin
    if(reset) begin
        shift_register <= 4'b0000;
        start_shifting <= 0;
    end else begin
        shift_register <= {shift_register[2:0], data};
        
        // Check if the sequence '1101' is detected
        if(shift_register == 4'b1101) begin
            start_shifting <= 1;
        end else if(start_shifting == 1 && ~reset) begin
            start_shifting <= 1; // Remain high until reset
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule