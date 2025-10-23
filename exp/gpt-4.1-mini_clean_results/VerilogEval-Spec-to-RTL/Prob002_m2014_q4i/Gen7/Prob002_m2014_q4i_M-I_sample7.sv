module TopModule(output wire out);
    // Synthesis directive to emphasize constant output (tool-dependent, optional)
    (* keep = "true" *) 
    assign out = 1'b0;
endmodule