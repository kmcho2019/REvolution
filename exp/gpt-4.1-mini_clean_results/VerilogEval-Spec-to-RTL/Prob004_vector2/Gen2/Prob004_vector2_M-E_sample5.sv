module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    wire [7:0] bytes_in [3:0];
    reg  [7:0] bytes_out [3:0];
    integer i;

    // Split input into bytes
    assign bytes_in[0] = in[31:24];
    assign bytes_in[1] = in[23:16];
    assign bytes_in[2] = in[15:8];
    assign bytes_in[3] = in[7:0];

    // Reverse the byte order
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            bytes_out[i] = bytes_in[3 - i];
        end
    end

    // Concatenate reversed bytes to output
    assign out = {bytes_out[0], bytes_out[1], bytes_out[2], bytes_out[3]};

endmodule