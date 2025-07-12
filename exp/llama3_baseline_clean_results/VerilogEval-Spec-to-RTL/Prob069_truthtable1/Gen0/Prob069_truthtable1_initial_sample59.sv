module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

    assign f = (x2 & ~x3 & ~x1) | 
               (x2 & ~x3 & x1) | 
               (~x3 & ~x2 & x1) | 
               (x3 & ~x2 & x1) | 
               (x3 & x2 & x1);

    // Alternative way using a case statement for clarity on minterms
    // always @(*) begin
    //     case({x3, x2, x1})
    //         4'b0010, 4'b0011, 4'b0101, 4'b1111: f = 1'b1;
    //         default: f = 1'b0;
    //     endcase
    // end

endmodule