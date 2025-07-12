module DFF (
    input clk,
    input rst_n,  // active-low asynchronous reset
    input d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  x,
    output z
);

    wire rst_n = 1'b1; // As no reset input port specified, tie reset to 1 (inactive)
                       // but for simulation, can be driven externally if needed.

    wire q_xor, q_and, q_or;
    wire d_xor, d_and, d_or;

    // Combinational logic for D inputs based on problem description
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Instantiate flip-flops with asynchronous reset tied high (inactive)
    DFF dff_xor (.clk(clk), .rst_n(rst_n), .d(d_xor), .q(q_xor));
    DFF dff_and (.clk(clk), .rst_n(rst_n), .d(d_and), .q(q_and));
    DFF dff_or  (.clk(clk), .rst_n(rst_n), .d(d_or),  .q(q_or));

    // Output is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule