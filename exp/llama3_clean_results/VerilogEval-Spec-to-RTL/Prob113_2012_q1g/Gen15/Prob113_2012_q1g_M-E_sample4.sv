module TopModule(
    input  [3:0] x,
    output       f
);

    wire [1:0] lsbs = x[1:0];
    wire [1:0] msbs = x[3:2];

    assign f = (msbs == 2'b00)? ((lsbs == 2'b00) | (lsbs == 2'b10)) :
               (msbs == 2'b01)? 1'b0 :
               (msbs == 2'b10)? ((lsbs == 2'b00) | (lsbs == 2'b01) | (lsbs == 2'b10)) :
               (msbs == 2'b11)? ((lsbs == 2'b00) | (lsbs == 2'b01) | (lsbs == 2'b11)) : 1'b0;

endmodule