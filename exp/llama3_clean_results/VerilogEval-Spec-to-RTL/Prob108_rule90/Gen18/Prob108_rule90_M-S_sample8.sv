module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
wire [511:0] next_state;

integer i;
always @(*) begin
    for (i = 0; i < 512; i++) begin
        wire left, right;
        if (i == 0) begin
            assign left = 1'b0;
        end else begin
            assign left = q_reg[i - 1];
        end
        if (i == 511) begin
            assign right = 1'b0;
        end else begin
            assign right = q_reg[i + 1];
        end
        assign next_state[i] = left ^ right;
    end
end

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule