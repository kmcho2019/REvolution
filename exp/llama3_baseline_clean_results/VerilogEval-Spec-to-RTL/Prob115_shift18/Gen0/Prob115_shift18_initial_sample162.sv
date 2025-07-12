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
            2'b01: q <= {q[55:0], 8'b0}; // shift left by 8 bits
            2'b10: q <= {{q[63] ? 64'b1 : 64'b0}[63:1], q[63]}; // arithmetic shift right by 1 bit
            2'b11: q <= {{q[63] ? 56'b1 : 56'b0}[55:0], q[63:8]}; // arithmetic shift right by 8 bits
            default: q <= q;
        endcase
    end else begin
        q <= q;
    end
end

endmodule