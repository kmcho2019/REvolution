module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers with direct output assignments
    reg [7:0] ins_p1 = 0;
    reg [7:0] ins_p2 = 0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            if (fetch == 2'b01) ins_p1 <= data;
            if (fetch == 2'b10) ins_p2 <= data;
        end
    end

    // Direct output assignments
    always @(*) begin
        ins = ins_p1[7:5];
        ad1 = ins_p1[4:0];
        ad2 = ins_p2;
    end

endmodule