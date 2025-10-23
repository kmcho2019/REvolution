module DFF_sync_reset_vec_en #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   reset,
    input                   clk_en,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else if (clk_en)
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    wire clk_en;
    reg [7:0] q_reg;

    // Generate clock enable: update only when d != q_reg or reset asserted
    assign clk_en = reset | (d != q_reg);

    // Instantiate vector DFF with synchronous reset and clock enable
    DFF_sync_reset_vec_en #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .clk_en(clk_en),
        .d(d),
        .q(q_reg)
    );

    assign q = q_reg;
endmodule