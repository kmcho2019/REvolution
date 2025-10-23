module TopModule (
    input [7:0] in,
    output [2:0] pos
);

assign pos = 
    (|in) ?  // Only evaluate if at least one bit is set
    (casez (in)
        8'b???????1: 3'd0;
        8'b??????10: 3'd1;
        8'b?????100: 3'd2;
        8'b????1000: 3'd3;
        8'b???10000: 3'd4;
        8'b??100000: 3'd5;
        8'b?1000000: 3'd6;
        8'b10000000: 3'd7;
        default: 3'd0;
    endcase) : 3'd0;

endmodule