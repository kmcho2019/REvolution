module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] buffer;
reg [6:0] start_ptr; // 7-bit counter for 100 positions

always @(posedge clk) begin
    if (load) begin
        buffer <= data;
        start_ptr <= 0;
    end else begin
        case (ena)
            2'b01: start_ptr <= (start_ptr + 99) % 100; // Rotate Right
            2'b10: start_ptr <= (start_ptr + 1) % 100; // Rotate Left
            default: start_ptr <= start_ptr; // No Rotation
        endcase
    end
end

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign q[i] = buffer[(start_ptr + i) % 100];
    end
endgenerate

endmodule