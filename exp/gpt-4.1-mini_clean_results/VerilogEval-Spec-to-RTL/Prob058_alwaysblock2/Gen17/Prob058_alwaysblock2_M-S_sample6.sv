module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Direct behavioral XOR for assign output
    assign out_assign = a ^ b;

    // Combinational always block directly assigns XOR
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block registers XOR on posedge clk
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule