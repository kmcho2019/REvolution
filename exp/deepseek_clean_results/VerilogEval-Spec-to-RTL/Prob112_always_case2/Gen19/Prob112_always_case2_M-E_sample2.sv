module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in[3]) begin          // Highest priority - bit 3
        pos = 2'b11;
    end
    else if (in[2]) begin     // Next priority - bit 2
        pos = 2'b10;
    end
    else if (in[1]) begin     // Then bit 1
        pos = 2'b01;
    end
    else if (in[0]) begin     // Finally bit 0
        pos = 2'b00;
    end
    else begin               // All zeros case
        pos = 2'b00;
    end
end

endmodule