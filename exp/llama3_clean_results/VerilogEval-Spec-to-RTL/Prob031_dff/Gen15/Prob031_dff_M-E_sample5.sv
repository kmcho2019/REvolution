module TopModule(
    input clk,
    input d,
    output reg q
);

reg [0:0] shift_reg; // A single-stage shift register

always @(posedge clk) begin
    // Shift the input value into the register
    shift_reg <= {d};
    
    // The output q is assigned the last value stored in the register
    q <= shift_reg[0];
end

endmodule