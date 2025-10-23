// Alternative implementation using always block
module TopModule (
    output reg zero
);
    // Permanent LOW output using procedural assignment
    always @(*) begin
        zero = 1'b0;
    end
endmodule