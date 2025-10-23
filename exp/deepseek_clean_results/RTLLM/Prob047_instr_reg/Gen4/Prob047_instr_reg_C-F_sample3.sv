module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Internal registers to store instructions
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Clock gating enable signal
    wire update_enable = (fetch == 2'b01) || (fetch == 2'b10);

    // Continuous output assignments for power efficiency
    assign ins = ins_p1[7:5];  // Opcode field
    assign ad1 = ins_p1[4:0];  // Address field 1
    assign ad2 = ins_p2;       // Full second instruction

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Active low synchronous reset
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else if (update_enable) begin
            // Case statement for better synthesis optimization
            case (fetch)
                2'b01: ins_p1 <= data;  // Source 1 update
                2'b10: ins_p2 <= data;  // Source 2 update
            endcase
        end
    end

endmodule