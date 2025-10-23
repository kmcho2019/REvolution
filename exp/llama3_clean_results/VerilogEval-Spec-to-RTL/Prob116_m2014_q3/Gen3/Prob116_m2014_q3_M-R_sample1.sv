module TopModule(
    input  [3:0] x,
    output f
    );

    wire f_x3_0, f_x3_1;

    // Logic for x[3] = 0
    assign f_x3_0 = (~x[0] & ~x[1] & ~x[2])? 0 : 
                    (~x[0] & x[1] & ~x[2])? 0 : 
                    (~x[0] & ~x[1] & x[2])? 0 : 0;

    // Logic for x[3] = 1
    assign f_x3_1 = (x[1] & x[2]) | 
                    (~x[0] & (x[1] | x[2]));

    // Use a multiplexer to select based on x[3]
    assign f = x[3]? f_x3_1 : f_x3_0;

endmodule