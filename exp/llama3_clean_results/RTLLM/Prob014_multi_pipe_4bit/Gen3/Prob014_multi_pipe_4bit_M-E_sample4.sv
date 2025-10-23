module multi_pipe_4bit(
    input               clk,
    input               rst_n,
    input   [3:0]       mul_a,
    input   [3:0]       mul_b,
    output  [7:0]       mul_out
);

parameter size = 4;

reg   [7:0]       shift_reg [3:0]; // Shift register array
reg   [7:0]       add_out; // Output of adder array
reg   [7:0]       pipe_reg1; // Pipeline register 1
reg   [7:0]       pipe_reg2; // Pipeline register 2

// Initialize shift register array with multiplicand shifted by different positions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < size; i++) begin
            shift_reg[i] <= 8'd0;
        end
        pipe_reg1 <= 8'd0;
        pipe_reg2 <= 8'd0;
    end else begin
        shift_reg[0] <= {4'd0, mul_a};
        for (int i = 1; i < size; i++) begin
            shift_reg[i] <= {shift_reg[i-1][6:0], 1'b0};
        end
        pipe_reg1 <= add_out;
        pipe_reg2 <= pipe_reg1;
    end
end

// Generate partial products and accumulate using adder array
always @(posedge clk) begin
    reg [7:0] temp;
    temp = 8'd0;
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            temp = temp + shift_reg[i];
        end
    end
    add_out <= temp;
end

// Output final product
assign mul_out = pipe_reg2;

endmodule