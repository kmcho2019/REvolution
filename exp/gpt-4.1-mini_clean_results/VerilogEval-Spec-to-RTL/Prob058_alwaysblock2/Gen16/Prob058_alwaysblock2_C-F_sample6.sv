module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment: combinational XOR output
    assign out_assign = a ^ b;

    // Combinational always block: direct XOR operation
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block: register XOR output on rising clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule