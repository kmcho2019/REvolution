module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] instr;
    reg       src_flag; // 0: fetch=01, 1: fetch=10

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr    <= 8'b0;
            src_flag <= 1'b0;
        end else begin
            case (fetch)
                2'b01: begin
                    instr    <= data;
                    src_flag <= 1'b0;
                end
                2'b10: begin
                    instr    <= data;
                    src_flag <= 1'b1;
                end
                default: begin
                    instr    <= instr;
                    src_flag <= src_flag;
                end
            endcase
        end
    end

    assign ins = (src_flag == 1'b0) ? instr[7:5] : 3'b000;
    assign ad1 = (src_flag == 1'b0) ? instr[4:0] : 5'b00000;
    assign ad2 = (src_flag == 1'b1) ? instr : 8'b00000000;

endmodule