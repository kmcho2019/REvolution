module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] ptr;  // Pointer to track rotation (0-99)

// Pointer update logic
always @(posedge clk) begin
    if (load) begin
        storage <= data;
        ptr <= 0;
    end else begin
        case (ena)
            2'b01: ptr <= (ptr == 7'd99) ? 0 : ptr + 1;  // Right rotate (ptr++)
            2'b10: ptr <= (ptr == 0) ? 7'd99 : ptr - 1;   // Left rotate (ptr--)
            default: ptr <= ptr;                          // No change
        endcase
    end
end

// Circular buffer read logic
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : rotate_out
        assign q[i] = storage[(ptr + i) % 100];
    end
endgenerate

endmodule