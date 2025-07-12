module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [15:0] instr_combined;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_combined <= 16'b0;
        end else begin
            case (fetch)
                2'b01: instr_combined[7:0]  <= data;       // ins_p1 portion
                2'b10: instr_combined[15:8] <= data;       // ins_p2 portion
                default: instr_combined <= instr_combined; // hold previous value
            endcase
        end
    end

    assign ins = instr_combined[7:5];       // high 3 bits of ins_p1 (lower byte)
    assign ad1 = instr_combined[4:0];       // low 5 bits of ins_p1
    assign ad2 = instr_combined[15:8];      // full 8 bits of ins_p2 (upper byte)

endmodule