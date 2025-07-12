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
            // Update only when corresponding fetch signal is active
            if (fetch[0]) ins_p1 <= data;
            if (fetch[1]) ins_p2 <= data;
        end
    end

    // Direct output assignments
    assign ins = ins_p1[7:5];  // Opcode bits
    assign ad1 = ins_p1[4:0];  // Register address
    assign ad2 = ins_p2;       // Full second source data

    /* Optional clock gating for power optimization:
    wire clk_enable = |fetch;
    wire gated_clk = clk & clk_enable;
    // Replace 'clk' with 'gated_clk' in always block if used
    */
endmodule