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

    // Register updates in separate always blocks for better optimization
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
        end
        else if (fetch[0]) begin
            ins_p1 <= data;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 0;
        end
        else if (fetch[1]) begin
            ins_p2 <= data;
        end
    end

    // Direct output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule