module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] dffs; // Internal signals for the DFFs

// Instantiate the DFFs
always @(posedge clk) begin
    if (!resetn) begin // Synchronous active-low reset
        dffs <= 4'b0000; // Reset all DFFs to 0
    end else begin
        dffs <= {dffs[2:0], in}; // Shift the bits
    end
end

assign out = dffs[3]; // Output is the last DFF's value

endmodule