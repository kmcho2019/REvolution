module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_reg <= 8'b0;
        end else begin
            if (fetch == 2'b01 || fetch == 2'b10) begin
                ins_reg <= data;
            end
            // else retain previous ins_reg
        end
    end

    assign ins = (fetch == 2'b01) ? ins_reg[7:5] : 3'b0;
    assign ad1 = (fetch == 2'b01) ? ins_reg[4:0] : 5'b0;
    assign ad2 = (fetch == 2'b10) ? ins_reg : 8'b0;

endmodule