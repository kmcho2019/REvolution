module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] input_reg;
reg [31:0] result_reg;
reg [4:0] count;
reg started;

always @ (posedge clk or posedge areset) begin
    if(areset) begin
        input_reg <= 32'b0;
        result_reg <= 32'b0;
        count <= 5'b0;
        started <= 1'b0;
        z <= 1'b0;
    end else begin
        if(!started) begin
            input_reg <= {input_reg[30:0], x};
            if(x) begin
                started <= 1'b1;
                result_reg <= ~(input_reg);
                count <= 5'b1;
            end
        end else begin
            result_reg <= result_reg + 1'b1;
            z <= result_reg[31];
            result_reg <= {result_reg[30:0], 1'b0};
            count <= count + 1'b1;
            if(count == 5'b100000) begin
                started <= 1'b0;
            end
        end
    end
end

endmodule