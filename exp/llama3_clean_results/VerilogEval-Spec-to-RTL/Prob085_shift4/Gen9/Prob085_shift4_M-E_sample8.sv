module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        case ({load, ena})
            2'b01: q_reg <= data; // Load has priority over enable
            2'b10: q_reg <= {1'b0, q_reg[3:1]}; // Shift right
            default: q_reg <= q_reg; // No operation
        endcase
    end
end

assign q = q_reg;

endmodule