module instr_reg (
    input wire clk,
    input wire rst,          // Active low reset
    input wire [1:0] fetch,
    input wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [7:0] instr_reg;
    reg source_sel;  // 0: from fetch=01, 1: from fetch=10, retain previous if no new fetch

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 8'b0;
            source_sel <= 1'b0;
        end else begin
            if (fetch == 2'b01) begin
                instr_reg <= data;
                source_sel <= 1'b0;
            end else if (fetch == 2'b10) begin
                instr_reg <= data;
                source_sel <= 1'b1;
            end
            // else keep previous values
        end
    end

    assign ins = (source_sel == 1'b0) ? instr_reg[7:5] : 3'b000;
    assign ad1 = (source_sel == 1'b0) ? instr_reg[4:0] : 5'b00000;
    assign ad2 = (source_sel == 1'b1) ? instr_reg : 8'b00000000;

endmodule