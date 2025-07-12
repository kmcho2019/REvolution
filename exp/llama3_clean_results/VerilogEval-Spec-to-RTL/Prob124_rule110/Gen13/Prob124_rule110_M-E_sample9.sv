module Cell(
    input clk,
    input load,
    input [511:0] data,
    input left,
    input right,
    output reg q
);

reg state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        // Rule 110 transition rules
        if (left == 1'b1 && state == 1'b1 && right == 1'b1) begin
            state <= 1'b0;
        end else if (left == 1'b1 && state == 1'b1 && right == 1'b0) begin
            state <= 1'b1;
        end else if (left == 1'b1 && state == 1'b0 && right == 1'b1) begin
            state <= 1'b1;
        end else if (left == 1'b1 && state == 1'b0 && right == 1'b0) begin
            state <= 1'b0;
        end else if (left == 1'b0 && state == 1'b1 && right == 1'b1) begin
            state <= 1'b1;
        end else if (left == 1'b0 && state == 1'b1 && right == 1'b0) begin
            state <= 1'b1;
        end else if (left == 1'b0 && state == 1'b0 && right == 1'b1) begin
            state <= 1'b1;
        end else begin
            state <= 1'b0;
        end
    end
end

assign q = state;

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

wire [511:0] left, right;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        Cell cell(
            .clk(clk),
            .load(load),
            .data(data[i]),
            .left(i == 0 ? 1'b0 : q[i - 1]),
            .right(i == 511 ? 1'b0 : q[i + 1]),
            .q(q[i])
        );
    end
endgenerate

endmodule