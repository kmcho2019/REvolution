module instr_reg (
    input  wire       clk,
    input  wire       rst,    // active low reset
    input  wire [1:0] fetch,
    input  wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [7:0] instr_reg;
    reg       src_is_2;       // flag indicating if stored instruction came from fetch=2'b10

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 8'b0;
            src_is_2  <= 1'b0;
        end else begin
            case (fetch)
                2'b01: begin
                    instr_reg <= data;
                    src_is_2  <= 1'b0;
                end
                2'b10: begin
                    instr_reg <= data;
                    src_is_2  <= 1'b1;
                end
                default: begin
                    instr_reg <= instr_reg;
                    src_is_2  <= src_is_2;
                end
            endcase
        end
    end

    assign ins = instr_reg[7:5];
    assign ad1 = instr_reg[4:0];
    assign ad2 = src_is_2 ? instr_reg : 8'b0;

endmodule