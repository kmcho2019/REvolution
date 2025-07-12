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

    reg [31:0] accumulator;
    
    always @* begin
        // Initialize accumulator with all zeros
        accumulator = 32'b0;
        
        // Shift and accumulate each input
        accumulator = (accumulator << 5) | a;
        accumulator = (accumulator << 5) | b;
        accumulator = (accumulator << 5) | c;
        accumulator = (accumulator << 5) | d;
        accumulator = (accumulator << 5) | e;
        accumulator = (accumulator << 5) | f;
        
        // Set the two LSB bits to '1'
        accumulator[1:0] = 2'b11;
    end

    // Split the accumulator into output bytes
    assign w = accumulator[31:24];
    assign x = accumulator[23:16];
    assign y = accumulator[15:8];
    assign z = accumulator[7:0];

endmodule