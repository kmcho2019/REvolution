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
            2'b11: q_reg <= data; // load has higher priority
            2'b01: begin
                q_reg <= {q_reg[2:0], 1'b0}; // right shift by one bit
            end
            default: q_reg <= q_reg; // hold current value
        endcase
    end
end

assign q = q_reg;

endmodule