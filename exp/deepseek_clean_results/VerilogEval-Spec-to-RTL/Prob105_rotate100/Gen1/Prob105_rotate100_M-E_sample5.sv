module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] ptr;  // Pointer to track rotation (0-99)

// Circular buffer selection
wire [199:0] circular_buffer = {storage, storage};
assign q = circular_buffer[ptr +: 100];

always @(posedge clk) begin
    if (load) begin
        storage <= data;
        ptr <= 7'd0;
    end else begin
        case (ena)
            2'b01: ptr <= (ptr == 7'd99) ? 7'd0 : ptr + 7'd1;  // Right rotate (ptr++)
            2'b10: ptr <= (ptr == 7'd0) ? 7'd99 : ptr - 7'd1;   // Left rotate (ptr--)
            default: ;  // No change
        endcase
    end
end

endmodule