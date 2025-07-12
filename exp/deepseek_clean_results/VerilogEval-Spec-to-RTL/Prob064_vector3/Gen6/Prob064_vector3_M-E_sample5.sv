module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    reg [31:0] temp_reg;
    
    always @(*) begin
        // Initialize the temporary register with inputs and padding
        temp_reg = {a, b, c, d, e, f, 2'b11};
        
        // Assign outputs by extracting 8-bit chunks
        w = temp_reg[31:24];
        x = temp_reg[23:16];
        y = temp_reg[15:8];
        z = temp_reg[7:0];
    end

endmodule