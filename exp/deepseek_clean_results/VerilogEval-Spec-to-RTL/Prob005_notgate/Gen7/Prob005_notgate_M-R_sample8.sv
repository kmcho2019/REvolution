module TopModule (
    input in,
    output reg out
);
    // Alternative implementation using always block
    always @(*) begin
        out = ~in;
    end
endmodule