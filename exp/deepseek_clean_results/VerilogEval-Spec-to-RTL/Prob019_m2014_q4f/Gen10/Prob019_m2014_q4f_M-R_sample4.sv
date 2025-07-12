module TopModule (
    input in1,
    input in2,
    output reg out
);
    // Alternative implementation using always block
    always @(*) begin
        out = in1 & ~in2;
    end
endmodule