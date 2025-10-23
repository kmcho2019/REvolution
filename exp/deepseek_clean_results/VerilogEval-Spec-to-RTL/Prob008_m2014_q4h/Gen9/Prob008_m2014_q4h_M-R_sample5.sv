module TopModule (
    input wire in,
    output reg out
);
    // Using always block for combinational logic
    always @(*) begin
        out = in;
    end
endmodule