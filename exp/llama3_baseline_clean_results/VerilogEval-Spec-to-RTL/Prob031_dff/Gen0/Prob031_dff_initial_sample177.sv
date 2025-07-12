module TopModule(
    input clk,  // Clock signal
    input d,   // Input data
    output reg q  // Output data
);

always @ (posedge clk) begin
    q <= d;  // Capture input data 'd' on the positive edge of 'clk'
end

endmodule