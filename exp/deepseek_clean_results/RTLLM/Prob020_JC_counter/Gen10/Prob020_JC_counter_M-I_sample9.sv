module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q,
    output reg complete_cycle
);

parameter WIDTH = 64;
(* async_reg = "true" *) reg [WIDTH-1:0] Q_reg;  // Explicit synthesis attribute

// Clock gating signals
wire all_ones = &Q_reg;
wire all_zeros = ~|Q_reg;
wire clk_enable = !(all_ones || all_zeros);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q_reg <= {WIDTH{1'b0}};
        complete_cycle <= 1'b0;
    end
    else if (clk_enable) begin
        Q_reg <= Q_reg[0] ? {1'b0, Q_reg[WIDTH-1:1]}  // Count down
                          : {1'b1, Q_reg[WIDTH-1:1]}; // Count up
        complete_cycle <= (Q_reg == {WIDTH{1'b0}});
    end
end

assign Q = Q_reg;

endmodule