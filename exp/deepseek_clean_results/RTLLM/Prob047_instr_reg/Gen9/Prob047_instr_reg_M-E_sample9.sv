module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // 16-bit shift register with parallel load capability
    reg [15:0] instr_buffer;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_buffer <= 16'b0;
        end else begin
            case (fetch)
                2'b01: instr_buffer[15:8] <= data;  // Load first instruction part
                2'b10: instr_buffer[7:0] <= data;   // Load second instruction part
                default: instr_buffer <= {instr_buffer[7:0], 8'b0};  // Shift mode (future use)
            endcase
        end
    end

    // Windowed field extraction
    assign ins = instr_buffer[15:13];  // Opcode from upper 3 bits of first instruction
    assign ad1 = instr_buffer[12:8];   // Address from lower 5 bits of first instruction
    assign ad2 = instr_buffer[7:0];    // Full second instruction

endmodule