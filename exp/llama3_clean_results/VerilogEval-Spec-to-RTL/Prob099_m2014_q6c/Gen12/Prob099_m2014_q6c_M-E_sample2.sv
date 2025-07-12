module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    Y1 = 0;
    Y3 = 0;

    case ({y, w})
        6'b000001_0: begin // A, w = 0
            Y1 = 1; // A to B
        end
        6'b000001_1: begin // A, w = 1
            // A to A
        end
        6'b000010_0: begin // B, w = 0
            // B to C
        end
        6'b000010_1: begin // B, w = 1
            Y3 = 1; // B to D
        end
        6'b000100_0: begin // C, w = 0
            // C to E
        end
        6'b000100_1: begin // C, w = 1
            Y3 = 1; // C to D
        end
        6'b001000_0: begin // D, w = 0
            Y1 = 1; // D to F
        end
        6'b001000_1: begin // D, w = 1
            // D to A
        end
        6'b010000_0: begin // E, w = 0
            // E to E
        end
        6'b010000_1: begin // E, w = 1
            Y3 = 1; // E to D
        end
        6'b100000_0: begin // F, w = 0
            Y1 = 1; // F to C (and then to B), B to A
        end
        6'b100000_1: begin // F, w = 1
            // F to D
        end
        default: begin
            // default case
        end
    endcase
end

endmodule