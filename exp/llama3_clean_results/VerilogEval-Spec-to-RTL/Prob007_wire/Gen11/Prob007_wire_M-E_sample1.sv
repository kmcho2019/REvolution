module BufferModule(
    input  in,
    output out
);
    
    assign out = in;

endmodule

module TopModule(
    input  in,
    output out
);
    
    BufferModule buffer_inst (
        .in(in),
        .out(out)
    );

endmodule