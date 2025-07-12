module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;
wire clk_en;

// Clock gating control - enable clock only when needed
assign clk_en = L | E;

// Priority logic: Load has higher priority than shift
assign next_Q = L ? R : 
                E ? w : Q;

// Sequential element with clock gating
always @(posedge clk) begin
    if (clk_en) begin
        Q <= next_Q;
    end
end

endmodule