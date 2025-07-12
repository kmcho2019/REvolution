module TopModule (
    input  [2:0] vec,
    output reg [2:0] outv,
    output reg       o2,
    output reg       o1,
    output reg       o0
);

    always @(*) begin
        outv = vec;
        // Use bitwise shift and mask to extract bits
        o0 = (vec >> 0) & 1'b1;
        o1 = (vec >> 1) & 1'b1;
        o2 = (vec >> 2) & 1'b1;
    end

endmodule