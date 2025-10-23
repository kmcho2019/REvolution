module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the shift register width
parameter WIDTH = 4;

// Define the shift register
reg [WIDTH-1:0] shift_register;

// Sequential logic to update the shift register
always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000;
        start_shifting <= 1'b0;
    end else begin
        shift_register <= {shift_register[2:0], data};
        if (shift_register == 4'b1101) begin
            start_shifting <= 1'b1;
        end
    end
end

endmodule