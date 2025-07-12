module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    assign out = (a & b & ~c & ~d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & d) | 
                 (a & b & c & d) | (a & ~b & c & d) | (a & b & ~c & ~d) | (~a & ~b & ~c & d);

    // Alternatively, we could express this using a case statement for better readability
    // always @(a, b, c, d) begin
    //     case ({c, d, a, b})
    //         4'b0000, 4'b0101, 4'b1100, 4'b1000: out = 0;
    //         4'b0001, 4'b0010, 4'b0111, 4'b1010: out = 1;
    //         default: out = 1'bx;
    //     endcase
    // end
endmodule