module TopModule (
    input  wire in,
    output reg  out
);
    // Combinational always block implementing NOT gate
    always @(*) begin
        out = ~in;
    end
endmodule