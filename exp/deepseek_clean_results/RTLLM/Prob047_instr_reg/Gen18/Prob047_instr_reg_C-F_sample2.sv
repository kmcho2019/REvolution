module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Internal registers
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Clocked register updates with synchronous reset
    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            // Update ins_p1 when fetch[0] is set (01)
            ins_p1 <= fetch[0] ? data : ins_p1;
            // Update ins_p2 when fetch[1] is set (10)
            ins_p2 <= fetch[1] ? data : ins_p2;
        end
    end

    // Direct output assignments (combinational)
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule