module TopModule(
    input d,
    input ena,
    output reg q
);
    // D latch implementation using always_latch
    always_latch begin
        if (ena) begin
            q = d;
        end
    end
endmodule