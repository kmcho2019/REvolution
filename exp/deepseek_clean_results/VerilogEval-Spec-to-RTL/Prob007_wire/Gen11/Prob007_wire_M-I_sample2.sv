module TopModule(input in, output out);
    (* keep *) assign out = in;  // Synthesis attribute to ensure the connection is preserved
endmodule