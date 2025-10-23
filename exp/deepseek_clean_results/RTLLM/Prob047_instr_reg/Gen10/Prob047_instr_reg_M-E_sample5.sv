module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Shadow buffer registers
    reg [7:0] ins_p1_active, ins_p1_shadow;
    reg [7:0] ins_p2_active, ins_p2_shadow;
    
    // Phase detection signals
    wire rising_phase = fetch[0];
    wire falling_phase = fetch[1];
    
    // Rising edge processing (source 1)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1_active <= 0;
            ins_p1_shadow <= 0;
        end
        else if (rising_phase) begin
            ins_p1_active <= data;
            ins_p1_shadow <= ins_p1_active;
        end
    end
    
    // Falling edge processing (source 2)
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2_active <= 0;
            ins_p2_shadow <= 0;
        end
        else if (falling_phase) begin
            ins_p2_active <= data;
            ins_p2_shadow <= ins_p2_active;
        end
    end
    
    // Output pipeline (synchronized to rising edge)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end
        else begin
            ins <= ins_p1_shadow[7:5];
            ad1 <= ins_p1_shadow[4:0];
            ad2 <= ins_p2_shadow;
        end
    end

endmodule