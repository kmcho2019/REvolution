module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] sum_reg;
    wire [3:0] sum_next;

    // First stage: binary addition
    assign sum_next = A + B + Cin;

    // Second stage: BCD correction
    always @(*) begin
        if (sum_next > 4'd9) begin
            Sum = sum_next + 4'd6;
            Cout = 1'b1;
        end else begin
            Sum = sum_next;
            Cout = Cin;
        end
    end

    // Register to store the result
    always @(posedge clk) begin
        sum_reg <= sum_next;
    end

endmodule