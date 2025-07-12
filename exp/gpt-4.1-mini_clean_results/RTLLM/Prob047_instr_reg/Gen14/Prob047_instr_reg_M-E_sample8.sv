module instr_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] fetch,
    input wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [7:0] instr_reg;
    reg [1:0] source_tag; // 2'b01 for ins_p1, 2'b10 for ins_p2, else 0

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 8'b0;
            source_tag <= 2'b00;
        end else begin
            case (fetch)
                2'b01: begin
                    instr_reg <= data;
                    source_tag <= 2'b01;
                end
                2'b10: begin
                    instr_reg <= data;
                    source_tag <= 2'b10;
                end
                default: begin
                    // retain previous values
                    instr_reg <= instr_reg;
                    source_tag <= source_tag;
                end
            endcase
        end
    end

    // Outputs depend on the last fetched source
    assign ins = (source_tag == 2'b01) ? instr_reg[7:5] : 3'b000;
    assign ad1 = (source_tag == 2'b01) ? instr_reg[4:0] : 5'b00000;
    assign ad2 = (source_tag == 2'b10) ? instr_reg : 8'b00000000;

endmodule