module BufferModule(input in, output out);
    assign out = in;
endmodule

module TopModule(input in, output out);
    wire intermediate;
    
    BufferModule b1(.in(in), .out(intermediate));
    BufferModule b2(.in(intermediate), .out(out));
endmodule