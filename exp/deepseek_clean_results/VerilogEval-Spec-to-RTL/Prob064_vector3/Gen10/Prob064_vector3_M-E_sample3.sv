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

    reg [31:0] combined;

    always @* begin
        // Initialize with padding bits
        combined = 32'b0;
        combined[1:0] = 2'b11;
        
        // Shift and insert each input
        combined[31:6] = {a, b, c, d, e, f};
    end

    // Extract output bytes
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule