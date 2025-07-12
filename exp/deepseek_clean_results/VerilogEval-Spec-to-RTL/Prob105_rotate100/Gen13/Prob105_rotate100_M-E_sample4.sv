module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] offset;  // 7 bits for 0-99

// Barrel shifter for output
wire [6:0] inv_offset = 7'd100 - offset;
wire [199:0] extended_data = {storage, storage};
assign q = extended_data[199-inv_offset -: 100];

always @(posedge clk) begin
    if (load) begin
        storage <= data;
        offset <= 0;
    end else begin
        case (ena)
            2'b01: offset <= (offset == 7'd99) ? 0 : offset + 1;  // Right rotate
            2'b10: offset <= (offset == 0) ? 7'd99 : offset - 1;  // Left rotate
            default: ;  // No change
        endcase
    end
end

endmodule