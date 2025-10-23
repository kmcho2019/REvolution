module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    // Circular buffer implementation
    reg [7:0] memory;
    reg [2:0] write_ptr;

    // Shift register with circular write
    always @(posedge clk) begin
        if (enable) begin
            memory[write_ptr] <= S;
            write_ptr <= write_ptr + 1;
        end
    end

    // Read multiplexer with binary encoding
    always @(*) begin
        case ({A,B,C})
            3'b000: Z = memory[(write_ptr) % 8];
            3'b001: Z = memory[(write_ptr + 1) % 8];
            3'b010: Z = memory[(write_ptr + 2) % 8];
            3'b011: Z = memory[(write_ptr + 3) % 8];
            3'b100: Z = memory[(write_ptr + 4) % 8];
            3'b101: Z = memory[(write_ptr + 5) % 8];
            3'b110: Z = memory[(write_ptr + 6) % 8];
            3'b111: Z = memory[(write_ptr + 7) % 8];
        endcase
    end

endmodule