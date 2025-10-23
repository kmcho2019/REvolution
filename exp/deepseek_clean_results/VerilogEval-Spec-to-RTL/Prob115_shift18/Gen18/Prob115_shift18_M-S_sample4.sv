module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena) begin
        case (amount)
            2'b00: q <= q << 1;        // Left by 1
            2'b01: q <= q << 8;        // Left by 8
            2'b10: q <= q >>> 1;       // Right by 1 (arithmetic)
            2'b11: q <= q >>> 8;       // Right by 8 (arithmetic)
        endcase
    end
end

endmodule