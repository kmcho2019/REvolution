module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [6:0] ptr; // Pointer to the current position in the buffer
reg [99:0] buffer; // Circular buffer to store the data

always @(posedge clk) begin
    if (load) begin
        buffer <= data;
        ptr <= 0; // Reset the pointer to the beginning of the buffer
    end else begin
        case (ena)
            2'b01: ptr <= (ptr + 99) % 100; // Rotate right by one bit
            2'b10: ptr <= (ptr + 1) % 100; // Rotate left by one bit
        endcase
    end
end

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        q[i] <= buffer[(ptr + i) % 100]; // Assign the rotated value to q
    end
end

endmodule