module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Wire to hold the replicated sign bit (in[7]) 24 times
    wire [23:0] sign_extension;
    
    assign sign_extension = {24{in[7]}};
    assign out = {sign_extension, in};
endmodule