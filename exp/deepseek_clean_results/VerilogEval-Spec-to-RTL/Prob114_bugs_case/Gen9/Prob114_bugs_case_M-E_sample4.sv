module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// LUT for output values
reg [3:0] code_lut [0:255];
// LUT for valid bits
reg valid_lut [0:255];

// Initialize LUTs
integer i;
initial begin
    // Default all outputs to 0 and invalid
    for (i = 0; i < 256; i = i + 1) begin
        code_lut[i] = 4'b0;
        valid_lut[i] = 1'b0;
    end
    
    // Set valid codes and their outputs
    code_lut[8'h45] = 4'd0; valid_lut[8'h45] = 1'b1;
    code_lut[8'h16] = 4'd1; valid_lut[8'h16] = 1'b1;
    code_lut[8'h1e] = 4'd2; valid_lut[8'h1e] = 1'b1;
    code_lut[8'h26] = 4'd3; valid_lut[8'h26] = 1'b1;
    code_lut[8'h25] = 4'd4; valid_lut[8'h25] = 1'b1;
    code_lut[8'h2e] = 4'd5; valid_lut[8'h2e] = 1'b1;
    code_lut[8'h36] = 4'd6; valid_lut[8'h36] = 1'b1;
    code_lut[8'h3d] = 4'd7; valid_lut[8'h3d] = 1'b1;
    code_lut[8'h3e] = 4'd8; valid_lut[8'h3e] = 1'b1;
    code_lut[8'h46] = 4'd9; valid_lut[8'h46] = 1'b1;
end

// Continuous assignments for outputs
assign out = code_lut[code];
assign valid = valid_lut[code];

endmodule