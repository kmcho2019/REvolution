module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(ena or d) begin
        if (ena)
            q = d;
        // else do nothing: q holds its value, inferring a latch
    end

endmodule