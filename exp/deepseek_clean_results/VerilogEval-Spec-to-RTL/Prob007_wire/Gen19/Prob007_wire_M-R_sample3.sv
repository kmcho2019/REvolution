module TopModule (
    input wire in,
    output wire out
);
    wire connection;
    
    assign connection = in;
    assign out = connection;
endmodule