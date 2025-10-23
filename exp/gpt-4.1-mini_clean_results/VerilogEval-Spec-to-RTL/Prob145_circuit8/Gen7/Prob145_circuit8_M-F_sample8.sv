module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock) begin
    if ((p === 1'bx) || (q === 1'bx)) begin
        // Initial unknown state: initialize to (0,0)
        p <= 1'b0;
        q <= 1'b0;
    end else begin
        case ({p, q, a})
            // Current state (p,q) and input a --> next state (p,q)

            // (0,0)
            3'b000: begin p <= 1'b0; q <= 1'b0; end
            3'b001: begin p <= 1'b1; q <= 1'b0; end

            // (1,0)
            3'b100: begin p <= 1'b0; q <= 1'b0; end
            3'b101: begin p <= 1'b1; q <= 1'b1; end

            // (1,1)
            3'b110: begin p <= 1'b0; q <= 1'b1; end
            3'b111: begin p <= 1'b1; q <= 1'b1; end

            // (0,1)
            3'b010: begin p <= 1'b0; q <= 1'b1; end
            3'b011: begin p <= 1'b1; q <= 1'b1; end

            default: begin
                // Should not occur; hold state
                p <= p;
                q <= q;
            end
        endcase
    end
end

endmodule