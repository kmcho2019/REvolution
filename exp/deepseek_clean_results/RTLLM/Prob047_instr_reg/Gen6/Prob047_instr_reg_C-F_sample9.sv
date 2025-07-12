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

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            // Only update when fetch indicates valid source
            if (fetch[0]) ins_p1 <= data;  // Register source
            if (fetch[1]) ins_p2 <= data;  // Memory source
        end
    end

    // Direct output assignments
    assign ins = ins_p1[7:5];  // Opcode field
    assign ad1 = ins_p1[4:0];  // Address field
    assign ad2 = ins_p2;       // Full memory data

endmodule