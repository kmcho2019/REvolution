module TopModule(
    input [3:0] x,  // x[3:4] = row select, x[1:2] = column select
    output reg f
);

always @(*) begin
    case (x[3:4])  // Row selection
        2'b00: begin
            case (x[1:2])  // Column selection
                2'b01: f = 1'b0;  // K-map[00][01] = 0
                default: f = 1'b1; // Don't-cares optimized to 1
            endcase
        end
        2'b01: begin
            case (x[1:2])
                2'b00: f = 1'b0;  // K-map[01][00] = 0
                2'b10: f = 1'b0;  // K-map[01][10] = 0
                2'b11: f = 1'b1;  // K-map[01][11] = 1
                default: f = 1'b1; // Don't-care optimized to 1
            endcase
        end
        2'b11: begin
            case (x[1:2])
                2'b00: f = 1'b1;  // K-map[11][00] = 1
                2'b01: f = 1'b1;  // K-map[11][01] = 1
                default: f = 1'b1; // Don't-cares optimized to 1
            endcase
        end
        2'b10: begin
            case (x[1:2])
                2'b00: f = 1'b1;  // K-map[10][00] = 1
                2'b01: f = 1'b1;  // K-map[10][01] = 1
                2'b11: f = 1'b0;  // K-map[10][11] = 0
                default: f = 1'b1; // Don't-care optimized to 1
            endcase
        end
    endcase
end

endmodule