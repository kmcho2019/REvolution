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
    wire p1_en, p2_en;

    // Enable signals for conditional updates
    assign p1_en = fetch == 2'b01;
    assign p2_en = fetch == 2'b10;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end else begin
            // Conditional register updates
            if (p1_en) ins_p1 <= data;
            if (p2_en) ins_p2 <= data;
            
            // Registered outputs to break timing path
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule