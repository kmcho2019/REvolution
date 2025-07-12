module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] count;

    // Internal wires for next digit values and carry signals
    wire [3:0] digit0, digit1, digit2, digit3;
    wire       c0, c1, c2;  // carry out from digits 0,1,2 increments

    // Extract each BCD digit from count
    assign digit0 = count[3:0];
    assign digit1 = count[7:4];
    assign digit2 = count[11:8];
    assign digit3 = count[15:12];

    // Increment digit0 (ones) with carry out c0
    wire [3:0] next_digit0;
    assign {c0, next_digit0} = (digit0 == 4'd9) ? {1'b1, 4'd0} : {1'b0, digit0 + 4'd1};

    // Increment digit1 (tens) with carry out c1
    wire [3:0] next_digit1;
    assign {c1, next_digit1} = (digit1 == 4'd9 && c0) ? {1'b1, 4'd0} :
                              (c0)                 ? {1'b0, digit1 + 4'd1} :
                                                     {1'b0, digit1};

    // Increment digit2 (hundreds) with carry out c2
    wire [3:0] next_digit2;
    assign {c2, next_digit2} = (digit2 == 4'd9 && c1) ? {1'b1, 4'd0} :
                              (c1)                   ? {1'b0, digit2 + 4'd1} :
                                                       {1'b0, digit2};

    // Increment digit3 (thousands) without further carry
    wire [3:0] next_digit3;
    assign next_digit3 = (digit3 == 4'd9 && c2) ? 4'd0 :
                         (c2)                   ? digit3 + 4'd1 :
                                                  digit3;

    // Enable signals indicate when digit increment happens
    // i.e., when a carry is generated from lower digit increment
    assign ena[0] = c0;
    assign ena[1] = c1;
    assign ena[2] = c2;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count <= {next_digit3, next_digit2, next_digit1, next_digit0};
        end
    end

    assign q = count;

endmodule