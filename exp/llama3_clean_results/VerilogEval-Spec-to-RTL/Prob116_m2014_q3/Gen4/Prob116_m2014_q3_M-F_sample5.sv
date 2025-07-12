module TopModule(
    input [3:0] x,
    output reg f // Declare 'f' as a reg for procedural assignment
);

always @(*) begin
    case ({x[3], x[0]}) // Focus on x[3]x[0] for the outer conditions
        2'b00: begin
            case ({x[1], x[2]}) // Inner conditions based on x[1]x[2]
                2'b00: f = 1'b0;
                2'b01: f = 1'b0;
                2'b11: f = 1'b0;
                2'b10: f = 1'b0;
            endcase
        end
        2'b01: begin
            case ({x[1], x[2]})
                2'b00: f = 1'b0;
                2'b01: f = 1'b0; // Misinterpretation corrected here
                2'b11: f = 1'b1;
                2'b10: f = 1'b0;
            endcase
        end
        2'b11: begin
            case ({x[1], x[2]})
                2'b00: f = 1'b1;
                2'b01: f = 1'b1;
                2'b11: f = 1'b0; // Corrected based on Karnaugh map
                2'b10: f = 1'b0;
            endcase
        end
        2'b10: begin
            case ({x[1], x[2]})
                2'b00: f = 1'b1;
                2'b01: f = 1'b1;
                2'b11: f = 1'b0;
                2'b10: f = 1'b0;
            endcase
        end
    endcase
end

endmodule