module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] ptr;  // Pointer to current start position

// Rotation logic
assign q = {storage, storage} >> (ptr * 1);  // Select 4-bit window based on ptr

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
        // Right shift is equivalent to moving pointer left (circular)
        ptr <= ptr + 1;
        // Zero-fill the new MSB position (ptr-1 mod 4)
        storage[ptr] <= 1'b0;
    end
end

endmodule