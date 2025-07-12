module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[0]})
        2'b00: begin
            case ({x[1], x[2]})
                2'b00, 2'b01, 2'b11, 2'b10: f = 1'b0; // All cases for x[3]x[0] = 00 yield f = 0
            endcase
        end
        2'b01: begin
            case ({x[1], x[2]})
                2'b00: f = 1'b0;
                2'b01: f = 1'b1; // Correct assignment based on the map
                2'b11: f = 1'b1;
                2'b10: f = 1'b0;
            endcase
        end
        2'b11: begin
            case ({x[1], x[2]})
                2'b00, 2'b01: f = 1'b1; // Both yield f = 1
                2'b11: f = 1'b0;
                2'b10: f = 1'b1; // Corrected assignment
            endcase
        end
        2'b10: begin
            case ({x[1], x[2]})
                2'b00, 2'b01: f = 1'b1; // Both yield f = 1
                2'b11: f = 1'b0;
                2'b10: f = 1'b1; // Corrected assignment
            endcase
        end
    endcase
end

endmodule