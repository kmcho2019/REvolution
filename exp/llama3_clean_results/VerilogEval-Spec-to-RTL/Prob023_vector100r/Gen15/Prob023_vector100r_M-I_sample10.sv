module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    // Using a generate block for a more concise and scalable implementation
    // Adding synthesis directives for area and power optimization
    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            // Specify area optimization goal for each assignment
            (* area_opt = "high" *) 
            (* power_opt = "high" *)
            assign out[i] = in[99 - i];
        end
    endgenerate

endmodule