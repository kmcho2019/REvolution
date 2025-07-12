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

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Active low reset - initialize registers
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            // Update registers based on fetch signal
            case (fetch)
                2'b01: ins_p1 <= data;    // Fetch to ins_p1
                2'b10: ins_p2 <= data;    // Fetch to ins_p2
                default: begin           // Retain previous values
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    // Output assignments (combinational)
    always @(*) begin
        ins = ins_p1[7:5];    // High 3 bits of ins_p1
        ad1 = ins_p1[4:0];    // Low 5 bits of ins_p1
        ad2 = ins_p2;         // Full 8 bits of ins_p2
    end

endmodule