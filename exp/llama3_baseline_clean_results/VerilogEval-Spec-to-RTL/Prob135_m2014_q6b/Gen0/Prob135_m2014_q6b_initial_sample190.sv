module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;

always @(*) begin
    case (y)
        3'b000: Y1_next = 1'b0; // State A
        3'b001: begin // State B
            if (~w) Y1_next = 1'b0; // B (0) --0--> C
            else Y1_next = 1'b1; // B (0) --1--> D
        end
        3'b010: begin // State C
            if (~w) Y1_next = 1'b1; // C (0) --0--> E
            else Y1_next = 1'b1; // C (0) --1--> D
        end
        3'b011: begin // State D
            if (~w) Y1_next = 1'b1; // D (0) --0--> F
            else Y1_next = 1'b0; // D (0) --1--> A
        end
        3'b100: begin // State E
            if (w) Y1_next = 1'b1; // E (1) --0--> E
            else Y1_next = 1'b1; // E (1) --1--> D
        end
        3'b101: begin // State F
            if (w) Y1_next = 1'b0; // F (1) --0--> C
            else Y1_next = 1'b1; // F (1) --1--> D
        end
        default: Y1_next = 1'bx;
    endcase
end

assign Y1 = y[1];

endmodule