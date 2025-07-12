module TopModule(a, b, c, out);
    input a, b, c;
    output out;

    assign out = (a) || ((~a) && (b) && (~c || c));

    // Alternative implementation using simpler logic based on the map
    // assign out = a || (b && c) || (b && ~c);
endmodule