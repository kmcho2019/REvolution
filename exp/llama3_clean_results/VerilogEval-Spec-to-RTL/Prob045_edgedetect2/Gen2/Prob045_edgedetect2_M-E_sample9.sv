module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] shift_reg [1:0];  // Shift register to store the last two values of each bit
reg [7:0] anyedge_reg;  // Register to store the output

// Initialize the shift register
initial begin
    shift_reg[0] = 8'b0;
    shift_reg[1] = 8'b0;
end

// Sequential logic to update the shift register and output
always @(posedge clk) begin
    // Shift the values in the shift register
    shift_reg[1] <= shift_reg[0];
    shift_reg[0] <= in;
    
    // Detect edges by comparing the current value with the previous two values
    for (int i = 0; i < 8; i++) begin
        if ((shift_reg[0][i] != shift_reg[1][i])) begin
            anyedge_reg[i] <= 1'b1;
        end else begin
            anyedge_reg[i] <= 1'b0;
        end
    end
end

// Continuous assignment to the output
assign anyedge = anyedge_reg;

endmodule