module DFF_sync_reset_negclk_vector_en #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input              clk,
    input              reset,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    // Combinational next state logic
    wire ce;                  // clock enable
    wire [WIDTH-1:0] q_next;

    // Clock enable: any bit different between d and q
    assign ce = |(d ^ q);

    // Next state mux between reset and input d
    assign q_next = reset ? RESET_VAL : (ce ? d : q);

    always @(negedge clk) begin
        q <= q_next;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_sync_reset_negclk_vector_en #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8 (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule