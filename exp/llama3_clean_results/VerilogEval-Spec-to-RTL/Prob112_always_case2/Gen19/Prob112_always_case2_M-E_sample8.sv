module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

reg [1:0] lower_bits_result, upper_bits_result;

always @(*) begin
    pos = 2'b00;
    if (in[1]) begin
        lower_bits_result = 2'b01;
    end else if (in[0]) begin
        lower_bits_result = 2'b00;
    end else begin
        lower_bits_result = 2'b00;
    end
    
    if (in[3]) begin
        upper_bits_result = 2'b10;
    end else if (in[2]) begin
        upper_bits_result = 2'b10;
    end else begin
        upper_bits_result = 2'b00;
    end

    if (in[3] || in[2]) begin
        pos = upper_bits_result;
    end else if (in[1] || in[0]) begin
        pos = lower_bits_result;
    end else begin
        pos = 2'b00;
    end
end

endmodule