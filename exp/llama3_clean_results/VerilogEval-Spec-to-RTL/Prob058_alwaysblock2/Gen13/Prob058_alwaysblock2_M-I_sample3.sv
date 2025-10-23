// Simplified TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Use a single combinational always block for both out_assign and out_always_comb
    always_comb begin
        out_assign = a ^ b;
        out_always_comb = a ^ b;
    end

    // Clocked always block with non-blocking assignment and considering reset condition
    // Assuming an active high reset for simplicity; adjust based on specific requirements
    reg reset;
    initial reset = 1'b1;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            out_always_ff <= 1'b0; // Reset the flip-flop
        end else begin
            out_always_ff <= a ^ b; // Use non-blocking assignment
        end
    end

endmodule