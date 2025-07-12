module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    // Load new data when cnt == 3, else shift left
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 2'd3;  // Initialize to 3 so load occurs right after reset
        end else if (cnt == 2'd3) begin
            shift_reg <= d;
            cnt       <= 2'd0;
        end else begin
            // Shift left by 1, filling LSB with 0 (or don't care since all bits serially output)
            shift_reg <= {shift_reg[2:0], 1'b0};
            cnt       <= cnt + 1'b1;
        end
    end

    // dout always outputs the MSB of shift_reg
    assign dout = shift_reg[3];
    // valid_out is high while serializing (cnt from 0 to 3)
    assign valid_out = (cnt <= 2'd3);

endmodule