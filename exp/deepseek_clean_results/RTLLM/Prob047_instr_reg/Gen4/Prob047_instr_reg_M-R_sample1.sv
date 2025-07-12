module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Internal registers to store instructions from different sources
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Clock gating signals
    wire update_p1 = (fetch == 2'b01);
    wire update_p2 = (fetch == 2'b10);

    // Register updates
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            ins_p1 <= update_p1 ? data : ins_p1;
            ins_p2 <= update_p2 ? data : ins_p2;
        end
    end

    // Continuous output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule