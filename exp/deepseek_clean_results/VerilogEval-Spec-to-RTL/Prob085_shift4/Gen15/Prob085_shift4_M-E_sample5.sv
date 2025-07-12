module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] pointer;  // Points to current position 0

// Circular rotation function
function [3:0] rotate_output;
    input [3:0] data;
    input [1:0] ptr;
    begin
        case (ptr)
            2'b00: rotate_output = data;
            2'b01: rotate_output = {data[0], data[3:1]};
            2'b10: rotate_output = {data[1:0], data[3:2]};
            2'b11: rotate_output = {data[2:0], data[3]};
        endcase
    end
endfunction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        storage <= 4'b0;
        pointer <= 2'b0;
    end else if (load) begin
        storage <= data;
        pointer <= 2'b0;  // Reset pointer on load
    end else if (ena) begin
        pointer <= pointer + 1;  // Circular increment
        storage[3] <= 1'b0;      // MSB becomes 0 on shift
    end
end

assign q = rotate_output(storage, pointer);

endmodule