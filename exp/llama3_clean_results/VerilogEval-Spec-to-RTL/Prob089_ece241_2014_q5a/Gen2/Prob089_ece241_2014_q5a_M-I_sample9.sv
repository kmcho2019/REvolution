module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] num = 32'd0; // to store the input number
reg add_one = 1'b0; // flag to add 1
reg state = 1'b0; // 1'b0: idle, 1'b1: calculate

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
        num <= 32'd0;
        add_one <= 1'b0;
        z <= 1'b0;
    end else begin
        if (state == 1'b0 && ~areset) begin
            state <= 1'b1;
        end else if (state == 1'b1 && areset) begin
            state <= 1'b0;
            num <= 32'd0;
            add_one <= 1'b0;
        end else if (state == 1'b1) begin
            num <= {num[30:0], ~x}; // shift left and add new bit
            if (x) begin
                add_one <= 1'b1; // if input bit is 1, set add_one flag
            end
            z <= (~num[0]) + add_one; // calculate 2's complement and output
        end
    end
end

endmodule