module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always_comb begin
    if (in[3]) begin
        pos = 2'b11;    // Highest priority: bit 3
    end
    else if (in[2]) begin
        pos = 2'b10;    // Next priority: bit 2
    end
    else if (in[1]) begin
        pos = 2'b01;    // Next priority: bit 1
    end
    else if (in[0]) begin
        pos = 2'b00;    // Next priority: bit 0
    end
    else begin
        pos = 2'b00;    // All zeros case
    end
end

endmodule