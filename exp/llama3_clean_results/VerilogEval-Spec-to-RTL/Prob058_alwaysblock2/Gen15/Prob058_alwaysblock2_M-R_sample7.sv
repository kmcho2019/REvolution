// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Implement assign statement for out_assign
    assign out_assign = a ^ b;

    // Implement combinational always block for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Implement clocked always block for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
    end

endmodule