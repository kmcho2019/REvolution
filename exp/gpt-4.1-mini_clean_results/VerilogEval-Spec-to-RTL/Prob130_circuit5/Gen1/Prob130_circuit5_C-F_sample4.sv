module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);
    always @(*) begin
        // Select output q based on input c:
        // c=0 -> q=b; c=1 -> q=e; c=2 -> q=a; c=3 -> q=d; else q=4'hF
        if (c < 4) begin
            case(c)
                4'h0: q = b;
                4'h1: q = e;
                4'h2: q = a;
                4'h3: q = d;
                default: q = 4'hF;  // This default is redundant here but keeps safe coding style
            endcase
        end else begin
            q = 4'hF;
        end
    end
endmodule