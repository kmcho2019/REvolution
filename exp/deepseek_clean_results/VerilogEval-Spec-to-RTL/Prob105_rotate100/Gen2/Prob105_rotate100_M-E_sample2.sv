module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] ptr;  // Rotation pointer (0-99)

// Extended storage with duplicated bits for circular access
wire [199:0] extended_storage = {storage, storage};

// Output selection based on pointer
assign q = extended_storage[ptr +: 100];

always @(posedge clk) begin
    if (load) begin
        storage <= data;
        ptr <= 7'd0;
    end else begin
        case (ena)
            2'b01: ptr <= (ptr == 7'd99) ? 7'd0 : ptr + 7'd1;  // Right rotate (ptr moves forward)
            2'b10: ptr <= (ptr == 7'd0) ? 7'd99 : ptr - 7'd1;   // Left rotate (ptr moves backward)
            default: ;  // No change
        endcase
    end
end

endmodule