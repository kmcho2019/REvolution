module TopModule (
    input wire d,
    input wire ena,
    output reg q
);
    always @(d or ena) begin
        if (ena)
            q = d;   // latch transparent when enabled
        // else q holds its value
    end
endmodule