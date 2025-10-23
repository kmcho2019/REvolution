// Novel TopModule using a shift register with load control
module TopModule(
    input clk,
    input load, // New load signal
    input [7:0] d,
    output reg [7:0] q = 8'b0
);

// Internal wire to connect DFFs
wire [7:0] dff_out;

// Generate 8 DFFs and connect them in series
reg [7:0] dff;

always @(posedge clk) begin
    if (load) begin
        // Load input d into the shift register
        dff <= d;
    end else begin
        // Shift the contents of the register
        dff <= {dff[6:0], dff[7]};
    end
end

// Assign the output of the shift register to q
always @(*) begin
    q = dff;
end

endmodule