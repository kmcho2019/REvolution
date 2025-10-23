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
    reg       source;  // 0 for fetch==01, 1 for fetch==10

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr  <= 8'b0;
            source <= 1'b0;
        end else begin
            if (fetch == 2'b01) begin
                instr  <= data;
                source <= 1'b0;
            end else if (fetch == 2'b10) begin
                instr  <= data;
                source <= 1'b1;
            end
        end
    end

    assign ins = source ? 3'b0 : instr[7:5];
    assign ad1 = source ? 5'b0 : instr[4:0];
    assign ad2 = source ? instr      : 8'b0;

endmodule