module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    always @(*) begin
        if (ena)
            q = d;
        else
            q = q; // latch hold condition
    end

endmodule