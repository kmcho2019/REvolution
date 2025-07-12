module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    // Output always reflects the MSB of shift_reg
    assign dout = shift_reg[3];

    // valid_out is high only when counter is 3 (new parallel data is available this cycle)
    assign valid_out = (cnt == 2'd3);

    // Counter: increments from 0 to 3, then wraps
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 2'b0;
        else
            cnt <= (cnt == 2'd3) ? 2'b0 : cnt + 1'b1;
    end

    // Shift register: load parallel input when counter is 3, else shift left by one bit
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 4'b0;
        else if (cnt == 2'd3)
            shift_reg <= d;
        else
            shift_reg <= {shift_reg[2:0], 1'b0};
    end

endmodule