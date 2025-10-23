module TopModule(input in, output out);
    (* keep *) assign out = in;  // Synthesis attribute to ensure this remains a wire
endmodule