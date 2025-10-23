module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

    reg [7:0] q_reg;  // Internal register for q

    // Chain of D-type flip-flops for each bit of q
    always @(posedge clk) begin
        q_reg[0] <= d;  // Input d goes into the first flip-flop
        for (int i = 1; i < 8; i++) begin
            q_reg[i] <= q_reg[i-1];  // Each flip-flop's output goes to the next one
        end
    end

    // Output q is the current state of all flip-flops
    assign q = q_reg;

endmodule