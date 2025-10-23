module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] ptr;  // 7-bit pointer (2^7=128 > 100)

// Circular buffer implementation
always @(posedge clk) begin
    if (load) begin
        storage <= data;
        ptr <= 7'd0;  // Reset pointer on load
    end else begin
        case (ena)
            2'b01: ptr <= (ptr == 7'd99) ? 7'd0 : ptr + 1;  // Right rotate (ptr++)
            2'b10: ptr <= (ptr == 7'd0) ? 7'd99 : ptr - 1;  // Left rotate (ptr--)
            default: ptr <= ptr;  // No change
        endcase
    end
end

// Output generation using circular addressing
assign q = {storage[ptr +: (100-ptr)], storage[0 +: ptr]};

endmodule