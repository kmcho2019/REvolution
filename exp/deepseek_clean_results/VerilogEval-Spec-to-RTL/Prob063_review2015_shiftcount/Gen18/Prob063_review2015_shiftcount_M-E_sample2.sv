module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] storage;
reg [1:0] ptr;  // Pointer to current MSB position
reg [3:0] output_map;

always @(posedge clk) begin
    if (shift_ena) begin
        // Circular shift: update pointer and store new data
        ptr <= ptr + 1;
        storage[ptr] <= data;
    end
    else if (count_ena) begin
        // Decrement value at current pointer position
        storage[ptr] <= storage[ptr] - 1'b1;
    end
end

// Output mapping based on pointer position
always @(*) begin
    case (ptr)
        2'b00: output_map = {storage[0], storage[3], storage[2], storage[1]};
        2'b01: output_map = {storage[1], storage[0], storage[3], storage[2]};
        2'b10: output_map = {storage[2], storage[1], storage[0], storage[3]};
        2'b11: output_map = {storage[3], storage[2], storage[1], storage[0]};
    endcase
end

assign q = output_map;

endmodule