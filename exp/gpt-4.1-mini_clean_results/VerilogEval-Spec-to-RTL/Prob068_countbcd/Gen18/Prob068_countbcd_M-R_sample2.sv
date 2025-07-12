module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] d0, d1, d2, d3;       // Current BCD digits

    wire carry0, carry1, carry2, carry3;
    wire [3:0] next_d0, next_d1, next_d2, next_d3;

    // Increment ones digit and generate carry
    assign {carry0, next_d0} = (d0 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d0 + 4'd1};

    // Increment tens digit with carry from ones digit
    assign {carry1, next_d1} = carry0 ?
                               ((d1 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d1 + 4'd1}) :
                               {1'b0, d1};

    // Increment hundreds digit with carry from tens digit
    assign {carry2, next_d2} = carry1 ?
                               ((d2 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d2 + 4'd1}) :
                               {1'b0, d2};

    // Increment thousands digit with carry from hundreds digit
    assign {carry3, next_d3} = carry2 ?
                               ((d3 == 4'd9) ? {1'b1, 4'd0} : {1'b0, d3 + 4'd1}) :
                               {1'b0, d3};

    // Enable signals: upper digits increment when lower digits are 9
    assign ena[0] = (d0 == 4'd9);
    assign ena[1] = ena[0] && (d1 == 4'd9);
    assign ena[2] = ena[1] && (d2 == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            d0 <= next_d0;
            d1 <= next_d1;
            d2 <= next_d2;
            d3 <= next_d3;
        end
    end

    assign q = {d3, d2, d1, d0};

endmodule