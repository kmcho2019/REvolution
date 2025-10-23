module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

wire [3:0] shift_data;
wire [3:0] load_data;
wire [3:0] q_next;

assign shift_data = {1'b0, q_reg[3:1]};
assign load_data = data;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        if (load) begin
            q_reg <= load_data;
        end else if (ena) begin
            q_reg <= shift_data;
        end
    end
end

assign q = q_reg;

endmodule