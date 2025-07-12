module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire [3:0] in = {a,b,c,d};
    // Define the output as 1 if the input matches one of the minterms
    assign out = (in == 4'd0)  || (in == 4'd1)  || (in == 4'd2)  || (in == 4'd4)  || 
                 (in == 4'd6)  || (in == 4'd7)  || (in == 4'd8)  || (in == 4'd9)  || 
                 (in == 4'd13) || (in == 4'd15);
endmodule