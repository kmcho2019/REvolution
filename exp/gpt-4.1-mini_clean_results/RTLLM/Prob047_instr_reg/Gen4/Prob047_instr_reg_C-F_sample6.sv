module instr_reg(
    input        clk,
    input        rst,    // active low synchronous reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [15:0] instr_combined;

    // Synchronous reset, single always block with clock enable for efficient update
    always @(posedge clk) begin
        if (!rst) begin
            instr_combined <= 16'b0;
        end else begin
            case (fetch)
                2'b01: instr_combined[7:0]  <= data;       // Update lower byte (ins_p1)
                2'b10: instr_combined[15:8] <= data;       // Update upper byte (ins_p2)
                default: instr_combined <= instr_combined; // Hold current value (no change)
            endcase
        end
    end

    assign ins = instr_combined[7:5];       // opcode from ins_p1
    assign ad1 = instr_combined[4:0];       // register address from ins_p1
    assign ad2 = instr_combined[15:8];      // full 8-bit data from ins_p2

endmodule