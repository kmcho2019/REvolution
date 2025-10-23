module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    // Concatenate all six 5-bit inputs into one 30-bit bus
    wire [29:0] input_concat = {a, b, c, d, e, f};

    // Append two LSB bits set to 1, forming 32-bit bus
    wire [31:0] combined = {input_concat, 2'b11};

    // Procedural block for splitting combined into outputs
    always @(*) begin
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end

endmodule