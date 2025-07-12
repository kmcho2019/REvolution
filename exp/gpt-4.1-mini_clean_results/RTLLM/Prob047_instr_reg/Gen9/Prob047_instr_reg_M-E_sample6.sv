module instr_reg (
    input        clk,
    input        rst,           // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1;  // Instruction from source 1 (fetch == 01)
    reg [7:0] ins_p2;  // Instruction from source 2 (fetch == 10)

    wire write_p1 = (fetch == 2'b01);
    wire write_p2 = (fetch == 2'b10);

    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (write_p1)
                ins_p1 <= data;
            if (write_p2)
                ins_p2 <= data;
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule