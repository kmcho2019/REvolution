module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else if (!tc) begin
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    assign tc = (shift_reg == 10'b0);

endmodule