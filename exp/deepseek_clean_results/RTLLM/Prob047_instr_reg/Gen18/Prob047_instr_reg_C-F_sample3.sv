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
    wire p1_update = fetch[0];  // Simple bit check
    wire p2_update = fetch[1];  // Simple bit check

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            // Independent synchronous updates
            ins_p1 <= p1_update ? data : ins_p1;
            ins_p2 <= p2_update ? data : ins_p2;
        end
    end

    // Direct output assignments - minimal logic
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule