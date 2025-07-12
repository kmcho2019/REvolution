module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    reg [15:0] result;
    integer i;

    always @(*) begin
        result = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) 
                result = result + (16'b0 + (A << i)); // shift A and add if bit set
        end
    end

    assign product = result;

endmodule