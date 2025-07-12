module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        out = in;  // Combinational logic using always block
    end
endmodule