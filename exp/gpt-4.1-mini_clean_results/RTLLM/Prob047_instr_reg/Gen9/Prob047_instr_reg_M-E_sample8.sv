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
    reg [1:0] last_fetch;

    always @(posedge clk) begin
        if (!rst) begin
            instr_reg  <= 8'b0;
            last_fetch <= 2'b00;
        end else begin
            if (fetch == 2'b01 || fetch == 2'b10) begin
                instr_reg  <= data;
                last_fetch <= fetch;
            end
        end
    end

    assign ins = instr_reg[7:5];
    assign ad1 = instr_reg[4:0];
    assign ad2 = (last_fetch == 2'b10) ? instr_reg : 8'b0;

endmodule