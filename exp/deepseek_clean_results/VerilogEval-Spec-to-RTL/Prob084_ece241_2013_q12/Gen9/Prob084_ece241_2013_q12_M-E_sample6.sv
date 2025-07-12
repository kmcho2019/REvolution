module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);
    reg [7:0] memory = 8'b00000000;  // Initialize all bits to 0
    
    always @(posedge clk) begin
        if (enable) begin
            // Shift operation: MSB first
            memory <= {memory[6:0], S};
        end
    end
    
    always @(*) begin
        case ({A, B, C})
            3'b000: Z = memory[0];
            3'b001: Z = memory[1];
            3'b010: Z = memory[2];
            3'b011: Z = memory[3];
            3'b100: Z = memory[4];
            3'b101: Z = memory[5];
            3'b110: Z = memory[6];
            3'b111: Z = memory[7];
            default: Z = 1'b0;
        endcase
    end
endmodule