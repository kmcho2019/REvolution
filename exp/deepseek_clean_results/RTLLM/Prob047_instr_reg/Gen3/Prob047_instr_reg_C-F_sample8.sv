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

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Active low reset - initialize registers
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            // Update registers based on fetch signal using case statement
            case (fetch)
                2'b01: ins_p1 <= data;  // Fetch to register 1
                2'b10: ins_p2 <= data;  // Fetch to register 2
                // No default needed - registers maintain value
            endcase
        end
    end

    // Continuous assignments for outputs - more efficient than always block
    assign ins = ins_p1[7:5];    // High 3 bits of ins_p1 (opcode)
    assign ad1 = ins_p1[4:0];    // Low 5 bits of ins_p1 (register address)
    assign ad2 = ins_p2;         // Full ins_p2 value (second source data)

endmodule