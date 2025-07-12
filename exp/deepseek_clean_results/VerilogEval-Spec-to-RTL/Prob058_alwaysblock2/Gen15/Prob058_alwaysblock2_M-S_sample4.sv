module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_ff
);

    // Continuous assignment for combinational XOR
    assign out_assign = a ^ b;

    // Sequential implementation for clocked XOR output
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule