module TopModule (
    input  clk,
    input  a,
    input  b,
    output      out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared wire for XOR operation to avoid redundant logic
    wire xor_val = a ^ b;

    // Continuous assignment output
    assign out_assign = xor_val;

    // Combinational always block assigning xor_val to output reg
    always @(*) begin
        out_always_comb = xor_val;  // Blocking assignment for combinational logic
    end

    // Sequential always block registering xor_val at clock edge
    always @(posedge clk) begin
        out_always_ff <= xor_val;   // Non-blocking assignment for sequential logic
    end

endmodule