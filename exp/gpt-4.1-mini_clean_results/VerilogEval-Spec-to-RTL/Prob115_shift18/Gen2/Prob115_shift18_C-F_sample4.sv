module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted;

    always @(*) begin
        // Use native shift operators for clarity and synthesis efficiency.
        // Shift left by 1 or 8 bits, or arithmetic right shift by 1 or 8 bits.
        case(amount)
            2'b00: shifted = q << 1;           // shift left by 1
            2'b01: shifted = q << 8;           // shift left by 8
            2'b10: shifted = q >>> 1;          // arithmetic shift right by 1
            2'b11: shifted = q >>> 8;          // arithmetic shift right by 8
            default: shifted = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule