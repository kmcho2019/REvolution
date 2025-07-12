module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if ((p === 1'bx) || (q === 1'bx)) begin
        p <= 1'b0;
        q <= 1'b0;
    end else begin
        case ({p,q,a})
            3'b000: begin p <= 0; q <= 0; end  // (0,0), a=0
            3'b001: begin p <= 1; q <= 0; end  // (0,0), a=1

            3'b100: begin p <= 0; q <= 0; end  // (1,0), a=0
            3'b101: begin p <= 1; q <= 1; end  // (1,0), a=1

            3'b110: begin p <= 0; q <= 1; end  // (1,1), a=0
            3'b111: begin p <= 1; q <= 1; end  // (1,1), a=1

            3'b010: begin p <= 0; q <= 1; end  // (0,1), a=0
            3'b011: begin p <= 1; q <= 1; end  // (0,1), a=1

            default: begin
                p <= p;
                q <= q;
            end
        endcase
    end
end

endmodule