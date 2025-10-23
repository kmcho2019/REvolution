module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    reg [4:0] temp_sum;

    always @(*) begin
        temp_sum = x + y;
    end

    assign sum = temp_sum;

endmodule