module instr_reg (
    input        clk,
    input        rst,           // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Combined register: upper byte = ins_p2, lower byte = ins_p1
    reg [15:0] instr_reg;

    wire wr_ins_p1 = (fetch == 2'b01);
    wire wr_ins_p2 = (fetch == 2'b10);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 16'b0;
        end else begin
            // Update only the targeted half to reduce unnecessary toggling
            if (wr_ins_p1)
                instr_reg[7:0] <= data;
            if (wr_ins_p2)
                instr_reg[15:8] <= data;
        end
    end

    // Extract ins and ad1 from lower byte (ins_p1)
    assign ins = instr_reg[7:5];    // bits 7 to 5 of ins_p1
    assign ad1 = instr_reg[4:0];    // bits 4 to 0 of ins_p1
    // ad2 is the full upper byte (ins_p2)
    assign ad2 = instr_reg[15:8];

endmodule