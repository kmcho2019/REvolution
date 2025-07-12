module TopModule(
    input  d,
    input  ena,
    output reg q
);

    // Use always @* for sensitivity, nonblocking assignment for clarity
    always @* begin
        if (ena)
            q <= d;  // latch transparent when ena is high
        else
            q <= q;  // hold state when ena is low
    end

endmodule