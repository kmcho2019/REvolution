module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] ptr;  // Rotation pointer (0-99)

// Pointer update logic
always @(posedge clk) begin
    if (load) begin
        storage <= data;
        ptr <= 0;
    end
    else case (ena)
        2'b01: ptr <= (ptr == 7'd99) ? 7'd0 : ptr + 1;  // Right rotate (ptr++)
        2'b10: ptr <= (ptr == 7'd0) ? 7'd99 : ptr - 1;   // Left rotate (ptr--)
        default: ptr <= ptr;
    endcase
end

// Output selection using pointer
assign q = {storage, storage} >> ptr;  // Concatenate to handle wrap-around

endmodule