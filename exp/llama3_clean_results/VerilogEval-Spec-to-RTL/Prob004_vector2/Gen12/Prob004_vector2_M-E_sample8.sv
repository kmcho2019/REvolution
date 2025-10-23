module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    task automatic reverse_bytes(input [31:0] data, output [31:0] result);
        integer i;
        reg [7:0] byte;
        begin
            result = 32'd0;  // Initialize result with zeros
            for (i = 0; i < 4; i++) begin
                // Extract the current byte from the input data
                byte = data[(i * 8) +: 8];
                // Assign the byte to its reversed position in the result
                result[(3 - i) * 8 +: 8] = byte;
            end
        end
    endtask

    always @(*) begin
        reverse_bytes(in, out);  // Call the task to reverse the byte order
    end

endmodule