module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] ptr;  // Rotation pointer (0-99)

// Virtual rotation function
function [99:0] rotate_out;
    input [99:0] in_data;
    input [6:0] rotation;
    integer i;
    begin
        for (i = 0; i < 100; i = i + 1) begin
            rotate_out[i] = in_data[(i + rotation) % 100];
        end
    end
endfunction

always @(posedge clk) begin
    if (load) begin
        storage <= data;
        ptr <= 7'd0;
    end else begin
        case (ena)
            2'b01: ptr <= (ptr == 7'd99) ? 7'd0 : ptr + 7'd1;  // Right rotate (ptr++)
            2'b10: ptr <= (ptr == 7'd0) ? 7'd99 : ptr - 7'd1;  // Left rotate (ptr--)
            default: ptr <= ptr;  // No change
        endcase
    end
end

assign q = rotate_out(storage, ptr);

endmodule