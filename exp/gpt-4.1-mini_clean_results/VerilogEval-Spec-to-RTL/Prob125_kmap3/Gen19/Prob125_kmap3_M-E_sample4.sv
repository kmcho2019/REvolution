module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored
    output out
);

// Define output for each combination of a and b as function of c

wire [1:0] sel = {a, b};

reg out_reg;

always @(*) begin
    case(sel)
        2'b00: begin // a=0, b=0
            // From K-map columns 00:
            // cd=00->0, 01->0, 11->1, 10->1
            // So out = 0 when c=0 except cd=10,11 (both c=1)
            // Simplify: for a=0,b=0, out= c
            out_reg = c;
        end
        2'b01: begin // a=0, b=1
            // columns 01:
            // 00->d, 01->0, 11->0, 10->0
            // d is don't-care, assign 0 for d positions for simplicity
            // So out=0 always here
            out_reg = 0;
        end
        2'b10: begin // a=1, b=0
            // columns 10:
            // 00->1, 01->d, 11->1, 10->1
            // For simplicity, d assigned 1
            // c=0: 00=1, 01=d=1, c=1: 11=1, 10=1 => output always 1
            out_reg = 1;
        end
        2'b11: begin // a=1, b=1
            // columns 11:
            // 00->1, 01->d, 11->1, 10->1
            // same as above, assign d=1
            out_reg = 1;
        end
        default: out_reg = 0; // safety fallback
    endcase
end

assign out = out_reg;

endmodule