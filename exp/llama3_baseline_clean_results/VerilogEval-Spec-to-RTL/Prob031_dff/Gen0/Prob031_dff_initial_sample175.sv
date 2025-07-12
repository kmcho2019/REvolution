module TopModule(
    input clk,  // Clock signal
    input d,    // Input data
    output reg q  // Output data
);

always @ (posedge clk) begin
    q <= d;  // Assign input data to output on positive edge of clock
end

endmodule