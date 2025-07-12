module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    reg [31:0] buffer;

    always @* begin
        // Initialize with padding in LSBs
        buffer = 32'b0;
        buffer[1:0] = 2'b11;
        
        // Shift in inputs from MSB to LSB
        buffer[31:27] = a;
        buffer[26:22] = b;
        buffer[21:17] = c;
        buffer[16:12] = d;
        buffer[11:7] = e;
        buffer[6:2] = f;
    end

    // Extract outputs
    assign w = buffer[31:24];
    assign x = buffer[23:16];
    assign y = buffer[15:8];
    assign z = buffer[7:0];

endmodule