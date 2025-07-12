module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Internal registers with clocked assignments
    reg [7:0] ins_p1 = 0;
    reg [7:0] ins_p2 = 0;

    // Register updates using ternary operators
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
        end else begin
            ins_p1 <= (fetch == 2'b01) ? data : ins_p1;
            ins_p2 <= (fetch == 2'b10) ? data : ins_p2;
        end
    end

    // Output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule