module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;

always @(*) begin
    case (y)
        3'b000: Y1_next = 1'b0; // State A
        3'b001: begin // State B
            if (~w) Y1_next = 1'b0; // To state C
            else Y1_next = 1'b1; // To state D
        end
        3'b010: begin // State C
            if (~w) Y1_next = 1'b0; // To state E
            else Y1_next = 1'b1; // To state D
        end
        3'b011: begin // State D
            if (~w) Y1_next = 1'b0; // To state F
            else Y1_next = 1'b0; // To state A
        end
        3'b100: begin // State E
            if (~w) Y1_next = 1'b1; // To state E
            else Y1_next = 1'b1; // To state D
        end
        3'b101: begin // State F
            if (~w) Y1_next = 1'b0; // To state C
            else Y1_next = 1'b0; // To state D
        end
        default: Y1_next = 1'bx;
    endcase
end

always @(posedge y[0] or posedge y[1] or posedge y[2] or posedge w) begin
    Y1 <= Y1_next;
end

assign Y1 = y[1];

endmodule