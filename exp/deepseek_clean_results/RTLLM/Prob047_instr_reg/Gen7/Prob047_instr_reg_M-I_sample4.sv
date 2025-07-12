module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
        end else begin
            // Synchronous enables for power optimization
            if (fetch[0]) ins_p1 <= data;
            if (fetch[1]) ins_p2 <= data;
        end
    end

    // Direct output assignments from registers
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule