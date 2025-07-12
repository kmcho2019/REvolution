module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Parameterized function to calculate XOR
    function automatic xor_func(input logic x, input logic y);
        xor_func = x ^ y;
    endfunction

    // Continuous assignment using the XOR function
    assign out_assign = xor_func(a, b);

    // Local wire to hold XOR result in combinational block
    wire xor_local = a ^ b;

    // Combinational always block uses local wire
    always @(*) begin
        out_always_comb = xor_local;
    end

    // Register inputs first
    reg a_reg, b_reg;

    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
    end

    // Sequential always_ff block computing XOR of registered inputs
    always @(posedge clk) begin
        out_always_ff <= a_reg ^ b_reg;
    end

endmodule