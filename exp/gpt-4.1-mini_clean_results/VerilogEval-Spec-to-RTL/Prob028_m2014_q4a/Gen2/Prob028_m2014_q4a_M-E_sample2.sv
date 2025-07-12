module TopModule(
    input d,
    input ena,
    output reg q
);
    // Implement a transparent D latch using a nonblocking assignment in a combinational always block
    // Sensitivity list includes d and ena to infer latch behavior
    always @(d or ena) begin
        if (ena)
            q <= d; // Transparent when ena is high: q follows d
        else
            q <= q; // Hold state when ena is low (feedback)
    end
endmodule