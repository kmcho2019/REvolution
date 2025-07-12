module instr_reg (
    input         clk,
    input         rst,
    input  [1:0]  fetch,
    input  [7:0]  data,
    output [2:0]  ins,
    output [4:0]  ad1,
    output [7:0]  ad2
);

    reg [15:0] instr_reg; // Upper byte for ins_p1, lower byte for ins_p2

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 16'b0;
        end else begin
            case(fetch)
                2'b01: instr_reg[15:8] <= data;  // Load upper byte
                2'b10: instr_reg[7:0]  <= data;  // Load lower byte
                default: instr_reg <= instr_reg; // Hold
            endcase
        end
    end

    assign ins = instr_reg[15:13];   // High 3 bits of upper byte
    assign ad1 = instr_reg[12:8];    // Low 5 bits of upper byte
    assign ad2 = instr_reg[7:0];     // Full lower byte

endmodule