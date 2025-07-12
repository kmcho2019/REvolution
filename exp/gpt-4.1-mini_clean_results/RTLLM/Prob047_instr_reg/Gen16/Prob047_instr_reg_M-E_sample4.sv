module instr_reg (
    input  wire        clk,
    input  wire        rst,    // Active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    // 9-bit register: bit8 is valid flag indicating if ins_p1 (fetch=01) or ins_p2 (fetch=10) data is stored
    // bit8 = 1 means ins_p1 valid (fetch=01), 0 means ins_p2 valid (fetch=10)
    reg [8:0] instr_reg;

    always @(posedge clk) begin
        if (!rst) begin
            instr_reg <= 9'b0;
        end else begin
            if (fetch == 2'b01) begin
                instr_reg <= {1'b1, data};  // MSB=1 for ins_p1 source
            end else if (fetch == 2'b10) begin
                instr_reg <= {1'b0, data};  // MSB=0 for ins_p2 source
            end
            // else retain previous value
        end
    end

    // Assign outputs based on valid bit
    assign ins = (instr_reg[8]) ? instr_reg[7:5] : 3'b000;       // Only valid if fetch=01 captured
    assign ad1 = (instr_reg[8]) ? instr_reg[4:0] : 5'b00000;     // Only valid if fetch=01 captured
    assign ad2 = (instr_reg[8]) ? 8'b0 : instr_reg[7:0];         // Valid if fetch=10 captured

endmodule