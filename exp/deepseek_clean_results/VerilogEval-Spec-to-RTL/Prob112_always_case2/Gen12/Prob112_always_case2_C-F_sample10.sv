module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in[0]) begin
        pos = 2'b00;    // Bit 0 has highest priority
    end
    else if (in[1]) begin
        pos = 2'b01;    // Bit 1 next
    end
    else if (in[2]) begin
        pos = 2'b10;    // Bit 2 next
    end
    else if (in[3]) begin
        pos = 2'b11;    // Bit 3 last
    end
    else begin
        pos = 2'b00;    // All zeros case
    end
end

endmodule