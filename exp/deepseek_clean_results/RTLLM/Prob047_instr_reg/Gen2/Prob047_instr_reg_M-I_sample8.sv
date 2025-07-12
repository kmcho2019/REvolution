module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers to store instructions from different sources
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Clock gating signals
    wire p1_en = fetch[0] & |fetch;  // Enable for ins_p1
    wire p2_en = fetch[1] & |fetch;  // Enable for ins_p2

    // Sequential logic for register updates with clock gating
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Active low reset - clear all registers
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            // Update registers only when enabled (clock gating)
            if (p1_en) ins_p1 <= data;
            if (p2_en) ins_p2 <= data;
            
            // Registered outputs (breaks combinational path)
            ins <= ins_p1[7:5];  // High 3 bits of ins_p1
            ad1 <= ins_p1[4:0];  // Low 5 bits of ins_p1
            ad2 <= ins_p2;       // Full ins_p2 value
        end
    end

endmodule