module instr_reg (
    input        clk,
    input        rst,      // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] instr_reg;
    reg       source_sel;  // 0: source 1 (register), 1: source 2 (RAM/ROM)

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 8'b0;
            source_sel <= 1'b0;
        end else begin
            case (fetch)
                2'b01: begin
                    instr_reg <= data;
                    source_sel <= 1'b0;
                end
                2'b10: begin
                    instr_reg <= data;
                    source_sel <= 1'b1;
                end
                default: begin
                    instr_reg <= instr_reg;
                    source_sel <= source_sel;
                end
            endcase
        end
    end

    // When source_sel==0 (source 1), assign ins and ad1 from instr_reg; else zero
    assign ins = (source_sel == 1'b0) ? instr_reg[7:5] : 3'b000;
    assign ad1 = (source_sel == 1'b0) ? instr_reg[4:0] : 5'b00000;

    // When source_sel==1 (source 2), assign ad2 from instr_reg; else zero
    assign ad2 = (source_sel == 1'b1) ? instr_reg : 8'b00000000;

endmodule