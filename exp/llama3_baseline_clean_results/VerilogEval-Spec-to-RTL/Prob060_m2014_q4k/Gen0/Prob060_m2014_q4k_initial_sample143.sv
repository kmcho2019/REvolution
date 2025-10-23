module TopModule(
    input  clk,
    input  resetn,
    input  in,
    output out
);

reg [3:0] dffs; // Declare an array of 4 reg to represent the 4 DFFs

always @(posedge clk) begin
    if (!resetn) begin // Active-low synchronous reset
        dffs <= 4'b0000; // Reset all DFFs to 0
    end else begin
        dffs <= {dffs[2:0], in}; // Shift 'in' through the DFFs
    end
end

assign out = dffs[3]; // Output 'out' is the value of the last DFF

endmodule