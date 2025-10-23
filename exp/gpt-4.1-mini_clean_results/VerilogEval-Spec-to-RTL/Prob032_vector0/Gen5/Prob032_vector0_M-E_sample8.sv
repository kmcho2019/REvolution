module TopModule (
    input  [2:0] vec,
    output reg [2:0] outv,
    output reg       o2,
    output reg       o1,
    output reg       o0
);

    always @(*) begin
        // Assign output vector from input vector
        outv = vec;
        // Split bits from outv to individual outputs
        o0 = outv[0];
        o1 = outv[1];
        o2 = outv[2];
    end

endmodule