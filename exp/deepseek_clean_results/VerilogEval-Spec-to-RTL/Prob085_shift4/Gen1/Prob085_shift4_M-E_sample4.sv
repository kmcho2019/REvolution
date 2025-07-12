module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] ptr;  // Pointer to virtual start position

// Circular access function
function [3:0] rotate_out;
    input [3:0] val;
    input [1:0] pointer;
    begin
        case (pointer)
            2'b00: rotate_out = val;
            2'b01: rotate_out = {val[0], val[3:1]};
            2'b10: rotate_out = {val[1:0], val[3:2]};
            2'b11: rotate_out = {val[2:0], val[3]};
        endcase
    end
endfunction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        storage <= 4'b0;
        ptr <= 2'b0;
    end
    else if (load) begin
        storage <= data;
        ptr <= 2'b0;
    end
    else if (ena) begin
        // Increment pointer with wrap-around
        ptr <= ptr + 1;
        // Clear the new end position (which is ptr+1 mod 4)
        case (ptr + 1)
            2'b00: storage[0] <= 1'b0;
            2'b01: storage[1] <= 1'b0;
            2'b10: storage[2] <= 1'b0;
            2'b11: storage[3] <= 1'b0;
        endcase
    end
end

assign q = rotate_out(storage, ptr);

endmodule