module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);
    reg [7:0] memory;
    wire [2:0] addr = {A, B, C};
    wire [7:0] next_memory;

    // Barrel shifter implementation
    assign next_memory = enable ? {memory[6:0], S} : memory;

    always @(posedge clk) begin
        memory <= next_memory;
        
        // Integrated decoder-mux
        case (addr)
            3'b000: Z <= memory[0];
            3'b001: Z <= memory[1];
            3'b010: Z <= memory[2];
            3'b011: Z <= memory[3];
            3'b100: Z <= memory[4];
            3'b101: Z <= memory[5];
            3'b110: Z <= memory[6];
            3'b111: Z <= memory[7];
        endcase
    end
endmodule