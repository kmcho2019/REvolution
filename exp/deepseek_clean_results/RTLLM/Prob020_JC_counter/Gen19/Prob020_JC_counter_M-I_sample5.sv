module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Registered feedback path for timing improvement
reg feedback_reg;
wire feedback = ~Q[0];

// Terminal state detection
wire all_zeros = (Q == 64'b0);
wire all_ones = (Q == 64'hFFFFFFFFFFFFFFFF);

// Clock gating control
wire clk_enable = !(all_zeros || all_ones);
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        feedback_reg <= 1'b1; // Initialize feedback for first shift
    end else begin
        // Registered feedback path
        feedback_reg <= feedback;
        
        // Johnson counter operation with registered feedback
        Q <= {feedback_reg, Q[63:1]};
    end
end

// Synthesis directives to preserve optimal structure
(* dont_touch = "true" *) reg [63:0] Q;
(* dont_touch = "true" *) reg feedback_reg;

endmodule