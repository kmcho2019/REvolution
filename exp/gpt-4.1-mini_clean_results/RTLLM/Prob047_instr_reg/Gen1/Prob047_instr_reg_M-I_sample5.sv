module instr_reg (
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    wire ins_p1_en = (fetch == 2'b01);
    wire ins_p2_en = (fetch == 2'b10);

    // Synchronous process with active low reset and clock enable signals
    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'd0;
            ins_p2 <= 8'd0;
        end else begin
            if (ins_p1_en)
                ins_p1 <= data;
            if (ins_p2_en)
                ins_p2 <= data;
        end
    end

    // Outputs derived from stored instructions
    assign ins = ins_p1[7:5];    // high 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];    // low 5 bits of ins_p1
    assign ad2 = ins_p2;         // full 8 bits of ins_p2

endmodule