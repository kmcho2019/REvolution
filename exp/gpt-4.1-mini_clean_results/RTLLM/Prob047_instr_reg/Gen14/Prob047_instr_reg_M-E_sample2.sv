module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] instr_reg;
    reg [1:0] src_sel;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 8'b0;
            src_sel <= 2'b00;
        end else begin
            if (fetch == 2'b01 || fetch == 2'b10) begin
                instr_reg <= data;
                src_sel <= fetch;
            end
        end
    end

    assign ins = (src_sel == 2'b01) ? instr_reg[7:5] : 3'b000;
    assign ad1 = (src_sel == 2'b01) ? instr_reg[4:0] : 5'b00000;
    assign ad2 = (src_sel == 2'b10) ? instr_reg : 8'b00000000;

endmodule