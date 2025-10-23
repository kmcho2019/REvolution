module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    reg [7:0] bytes[3:0];
    reg [31:0] reversed;

    integer i;
    always @(*) begin
        // Extract bytes from input
        for (i = 0; i < 4; i = i + 1) begin
            bytes[i] = in[i*8 +: 8];
        end
        // Reassemble bytes in reversed order
        reversed = {bytes[0], bytes[1], bytes[2], bytes[3]};  // Temporary placeholder
        for (i = 0; i < 4; i = i + 1) begin
            reversed[(i*8) +: 8] = bytes[3 - i];
        end
    end

    assign out = reversed;

endmodule