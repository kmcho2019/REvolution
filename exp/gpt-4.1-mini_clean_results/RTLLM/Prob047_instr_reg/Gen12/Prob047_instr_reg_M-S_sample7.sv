module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] instr;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr <= 8'b0;
        end else if (fetch == 2'b01 || fetch == 2'b10) begin
            instr <= data;
        end
    end

    assign ins = (fetch == 2'b01) ? instr[7:5] : 3'b0;
    assign ad1 = (fetch == 2'b01) ? instr[4:0] : 5'b0;
    assign ad2 = (fetch == 2'b10) ? instr : 8'b0;

endmodule