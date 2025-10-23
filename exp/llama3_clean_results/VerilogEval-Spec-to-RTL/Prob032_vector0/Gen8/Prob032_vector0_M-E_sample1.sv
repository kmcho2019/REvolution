module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Use a case statement to define the LUT
always @(*) begin
    case (vec)
        3'b000: begin
            outv = 3'b000;
            o2 = 1'b0;
            o1 = 1'b0;
            o0 = 1'b0;
        end
        3'b001: begin
            outv = 3'b001;
            o2 = 1'b0;
            o1 = 1'b0;
            o0 = 1'b1;
        end
        3'b010: begin
            outv = 3'b010;
            o2 = 1'b0;
            o1 = 1'b1;
            o0 = 1'b0;
        end
        3'b011: begin
            outv = 3'b011;
            o2 = 1'b0;
            o1 = 1'b1;
            o0 = 1'b1;
        end
        3'b100: begin
            outv = 3'b100;
            o2 = 1'b1;
            o1 = 1'b0;
            o0 = 1'b0;
        end
        3'b101: begin
            outv = 3'b101;
            o2 = 1'b1;
            o1 = 1'b0;
            o0 = 1'b1;
        end
        3'b110: begin
            outv = 3'b110;
            o2 = 1'b1;
            o1 = 1'b1;
            o0 = 1'b0;
        end
        3'b111: begin
            outv = 3'b111;
            o2 = 1'b1;
            o1 = 1'b1;
            o0 = 1'b1;
        end
        default: begin
            outv = 3'bxxx;
            o2 = 1'bx;
            o1 = 1'bx;
            o0 = 1'bx;
        end
    endcase
end

endmodule