module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] pos; // 7 bits needed for 0-99

always @(posedge clk) begin
    if (load) begin
        storage <= data;
        pos <= 7'd0;
    end else begin
        case (ena)
            2'b01: pos <= (pos == 7'd99) ? 7'd0 : pos + 1; // Right rotate (decrement position)
            2'b10: pos <= (pos == 7'd0) ? 7'd99 : pos - 1; // Left rotate (increment position)
            default: pos <= pos; // No change
        endcase
    end
end

// Circular access logic
assign q = {storage[pos -: 100], storage[99:pos + 1]};

endmodule