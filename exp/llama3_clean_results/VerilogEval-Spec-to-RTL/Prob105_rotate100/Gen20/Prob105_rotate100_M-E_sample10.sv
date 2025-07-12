module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

assign q = q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: // Rotate right
                q_reg <= {q_reg[0], q_reg[99:1]};
            2'b10: // Rotate left
                q_reg <= {q_reg[98:0], q_reg[99]};
            default: // No rotation
                q_reg <= q_reg;
        endcase
    end
end

// Hierarchical barrel shifter structure
// Divide the 100-bit register into 4 segments of 25 bits each
// Use a 2:1 multiplexer to select between the original bit position and the rotated bit position
// Use a hierarchical approach to rotate the bits
reg [24:0] segment0, segment1, segment2, segment3;

always @(posedge clk) begin
    if (load) begin
        segment0 <= data[24:0];
        segment1 <= data[49:25];
        segment2 <= data[74:50];
        segment3 <= data[99:75];
    end else begin
        case (ena)
            2'b01: // Rotate right
                segment0 <= {segment0[0], segment0[24:1]};
                segment1 <= {segment1[0], segment1[24:1]};
                segment2 <= {segment2[0], segment2[24:1]};
                segment3 <= {segment3[0], segment3[24:1]};
            2'b10: // Rotate left
                segment0 <= {segment0[23:0], segment0[24]};
                segment1 <= {segment1[23:0], segment1[24]};
                segment2 <= {segment2[23:0], segment2[24]};
                segment3 <= {segment3[23:0], segment3[24]};
            default: // No rotation
                segment0 <= segment0;
                segment1 <= segment1;
                segment2 <= segment2;
                segment3 <= segment3;
        endcase
    end
    q_reg <= {segment3, segment2, segment1, segment0};
end

endmodule