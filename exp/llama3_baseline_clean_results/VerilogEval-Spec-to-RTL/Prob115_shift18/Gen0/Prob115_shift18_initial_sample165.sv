module TopModule(
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
    end else if (ena) begin
        case (amount)
            2'b00: q <= {q[62:0], 1'b0}; // shift left by 1 bit
            2'b01: q <= {q[56:0], {8{1'b0}}}; // shift left by 8 bits
            2'b10: q <= {{63{q[63]}}, q[63:1]}; // shift right by 1 bit
            2'b11: q <= {{56{q[63]}}, q[63:8]}; // shift right by 8 bits
            default: q <= q; // default: no shift
        endcase
    end else begin
        // do nothing when ena is low
    end
end

endmodule