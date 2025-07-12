module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg [1:0] lut_out;

always @(*) begin
    case ({j, k})
        2'b00: lut_out = {1'b0, Q}; // No change
        2'b01: lut_out = 2'b00;     // Reset
        2'b10: lut_out = 2'b10;     // Set
        2'b11: lut_out = {1'b0, ~Q}; // Toggle
    endcase
end

always @(posedge clk) begin
    Q <= lut_out[0];
end

endmodule