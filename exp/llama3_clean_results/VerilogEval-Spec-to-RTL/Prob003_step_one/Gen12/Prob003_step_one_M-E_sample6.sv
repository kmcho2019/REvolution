module TopModule (
    output reg one
);

initial one = 1'b1;
always @(posedge one) one <= 1'b1;

endmodule