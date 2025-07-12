module TopModule (
    input  wire in1,
    input  wire in2,
    output reg  out
);

    // Compute output with in2 inverted inside procedural block
    always @(*) begin
        out = in1 & (~in2);
    end

endmodule