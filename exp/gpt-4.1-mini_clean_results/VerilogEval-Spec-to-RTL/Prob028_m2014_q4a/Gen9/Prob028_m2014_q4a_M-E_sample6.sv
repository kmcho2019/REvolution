module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(posedge ena or negedge ena) begin
        if (ena)
            q <= d;  // Capture input d when enable is high
        else
            q <= q;  // Hold the previous value when enable is low
    end

endmodule