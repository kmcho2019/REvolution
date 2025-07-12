module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] data_reg;
    reg [1:0] pos_reg;
    wire [1:0] next_pos = pos_reg + 1'b1;

    always @(posedge clk) begin
        if (!resetn) begin
            data_reg <= 4'b0;
            pos_reg <= 2'b0;
        end else begin
            data_reg[next_pos] <= in;
            pos_reg <= next_pos;
        end
    end

    assign out = data_reg[pos_reg];

endmodule