module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// 4-bit shift register to store the last four bits of the input stream
reg [3:0] shift_reg;

// Register to store the detection status
reg detected;

// Initialize the shift register and detection status
initial begin
    shift_reg = 4'b0000;
    detected = 0;
end

// Shift the register and add the new input bit
always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000;
        detected <= 0;
        start_shifting <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        if(shift_reg == 4'b1101 && !detected) begin
            detected <= 1;
        end
        if(detected || (shift_reg == 4'b1101)) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule