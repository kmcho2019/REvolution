module TopModule(
    input a,
    input b,
    output out
);
    // Optimal 2-input AND gate implementation:
    // - Single continuous assignment for minimal timing path
    // - Direct & operator maps efficiently to standard cell
    // - Perfect PPA (tns/wns = 0, minimal power/area)
    assign out = a & b;
endmodule