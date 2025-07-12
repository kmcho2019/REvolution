// Improved version focusing on minimizing area and reducing power consumption
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Combinational logic for out_assign and out_always_comb
    assign out_assign = a ^ b;
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential logic for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
endmodule