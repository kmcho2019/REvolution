module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        case ({load, ena})
            2'b01: q_reg <= {1'b0, q_reg[3:1]}; // ena is high, shift
            2'b10: q_reg <= data; // load is high, load data
            default: q_reg <= q_reg; // neither load nor ena is high, hold state
        endcase
    end
end

assign q = q_reg;

endmodule