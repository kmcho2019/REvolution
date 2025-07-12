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
    wire p1_update = fetch[0] & (|fetch);  // Qualified enable
    wire p2_update = fetch[1] & (|fetch);  // Qualified enable

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            // Qualified synchronous updates
            if (p1_update) ins_p1 <= data;
            if (p2_update) ins_p2 <= data;
        end
    end

    // Direct output assignments - minimal logic
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule