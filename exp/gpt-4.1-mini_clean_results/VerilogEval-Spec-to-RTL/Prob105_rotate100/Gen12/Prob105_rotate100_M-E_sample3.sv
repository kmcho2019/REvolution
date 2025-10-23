module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);
    // Internal storage as array of 1-bit registers
    reg bits_reg [0:99];
    integer i;

    // Convert q vector to bits_reg on reset or initialization - 
    // but since asynchronous reset is not specified, initialize on load

    always @(posedge clk) begin
        if (load) begin
            // Load data bitwise into bits_reg
            for (i = 0; i < 100; i = i + 1) begin
                bits_reg[i] <= data[i];
            end
        end else begin
            case (ena)
                2'b01: begin
                    // Rotate right by one bit
                    // bits_reg[0] gets bits_reg[99], and other bits shift right
                    reg temp;
                    temp = bits_reg[0];
                    for (i = 0; i < 99; i = i + 1) begin
                        bits_reg[i] <= bits_reg[i+1];
                    end
                    bits_reg[99] <= temp;
                end
                2'b10: begin
                    // Rotate left by one bit
                    // bits_reg[99] gets bits_reg[0], other bits shift left
                    reg temp;
                    temp = bits_reg[99];
                    for (i = 99; i > 0; i = i -1) begin
                        bits_reg[i] <= bits_reg[i-1];
                    end
                    bits_reg[0] <= temp;
                end
                default: begin
                    // No rotation, hold bits_reg
                    for (i = 0; i < 100; i = i + 1) begin
                        bits_reg[i] <= bits_reg[i];
                    end
                end
            endcase
        end
    end

    // Pack bits_reg array into output q vector combinationally
    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            q[i] = bits_reg[i];
        end
    end

endmodule