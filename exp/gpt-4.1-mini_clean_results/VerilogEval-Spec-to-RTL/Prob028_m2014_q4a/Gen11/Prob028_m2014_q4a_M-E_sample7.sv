module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q <= d;
        // else q keeps its previous value (latch)
    end
endmodule