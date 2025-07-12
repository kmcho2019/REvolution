module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] running_sum;
reg [31:0] output_reg;
reg start_flag;

initial begin
    running_sum = 0;
    output_reg = 0;
    start_flag = 0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        running_sum <= 0;
        output_reg <= 0;
        start_flag <= 0;
    end else begin
        if (!start_flag) begin
            running_sum <= ~x;
            output_reg <= ~x;
            start_flag <= 1;
        end else begin
            running_sum <= {running_sum[30:0], ~x};
            output_reg <= {output_reg[30:0], ~x};
        end
    end
end

always @(posedge areset) begin
    if (areset) begin
        z <= 0;
    end else begin
        if (start_flag) begin
            if (running_sum[31] == 1) begin
                z <= output_reg[0] + 1;
            end else begin
                z <= output_reg[0];
            end
        end else begin
            z <= 0;
        end
    end
end

endmodule