module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Instruction storage registers
    reg [7:0] ins_p1, ins_p1_prev;
    reg [7:0] ins_p2, ins_p2_prev;
    
    // Change detection signals
    wire p1_changed = |(ins_p1 ^ ins_p1_prev);
    wire p2_changed = |(ins_p2 ^ ins_p2_prev);

    // Rising edge: Handle fetch operations
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            ins_p1_prev <= 8'b0;
            ins_p2_prev <= 8'b0;
        end else begin
            ins_p1_prev <= ins_p1;
            ins_p2_prev <= ins_p2;
            
            case (fetch)
                2'b01: ins_p1 <= data;
                2'b10: ins_p2 <= data;
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    // Falling edge: Update outputs only when inputs change
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            if (p1_changed) begin
                ins <= ins_p1[7:5];
                ad1 <= ins_p1[4:0];
            end
            if (p2_changed) begin
                ad2 <= ins_p2;
            end
        end
    end

endmodule