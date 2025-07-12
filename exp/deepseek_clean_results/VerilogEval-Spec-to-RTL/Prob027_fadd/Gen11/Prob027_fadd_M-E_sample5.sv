module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum implementation using 4:1 mux
    wire [3:0] mux_in;
    assign mux_in[0] = cin;      // a=0, b=0
    assign mux_in[1] = ~cin;     // a=0, b=1
    assign mux_in[2] = ~cin;     // a=1, b=0
    assign mux_in[3] = cin;      // a=1, b=1
    
    assign sum = mux_in[{a,b}];  // Using a,b as select lines
    
    // Carry-out implementation using 2:1 mux
    assign cout = cin ? (a | b) : (a & b);
endmodule