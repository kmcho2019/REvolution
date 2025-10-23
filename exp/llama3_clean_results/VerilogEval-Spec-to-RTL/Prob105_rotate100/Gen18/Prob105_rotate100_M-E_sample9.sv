module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] buffer;
reg [6:0] rotation_offset;

always @(posedge clk) begin
    if (load) begin
        buffer <= data;
        rotation_offset <= 0;
    end else begin
        case (ena)
            2'b01: rotation_offset <= rotation_offset + 1; // Rotate Right
            2'b10: rotation_offset <= rotation_offset - 1; // Rotate Left
            default: ; // No Rotation
        endcase
    end
end

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign q[i] = buffer[(i + rotation_offset) % 100];
    end
endgenerate

endmodule