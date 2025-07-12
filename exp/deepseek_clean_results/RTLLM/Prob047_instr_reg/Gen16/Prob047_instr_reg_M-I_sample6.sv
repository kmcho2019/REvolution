module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    wire clk_enable = |fetch;  // Clock gating control

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end else if (clk_enable) begin  // Clock gating implementation
            // Register updates
            if (fetch[0]) ins_p1 <= data;
            if (fetch[1]) ins_p2 <= data;
            
            // Pipelined output assignments
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule