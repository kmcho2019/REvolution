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
    reg ins_p2_sel;  // 1 if last fetched from source 2 (fetch=10), 0 otherwise

    wire ce = (fetch == 2'b01) || (fetch == 2'b10);

    always @(posedge clk) begin
        if (!rst) begin
            instr_reg  <= 8'b0;
            ins_p2_sel <= 1'b0;
        end else if (ce) begin
            instr_reg  <= data;
            ins_p2_sel <= (fetch == 2'b10);
        end
    end

    assign ins = instr_reg[7:5];
    assign ad1 = instr_reg[4:0];
    assign ad2 = ins_p2_sel ? instr_reg : 8'b0;

endmodule