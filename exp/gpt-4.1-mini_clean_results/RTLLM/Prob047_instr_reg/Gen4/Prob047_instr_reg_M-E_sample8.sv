module instr_reg (
    input        clk,
    input        rst,           // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] instr_reg;
    reg [1:0] src_flag; // 2'b01 for ins_p1 source, 2'b10 for ins_p2 source, 2'b00 none

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 8'd0;
            src_flag  <= 2'b00;
            ins       <= 3'd0;
            ad1       <= 5'd0;
            ad2       <= 8'd0;
        end else begin
            if (fetch == 2'b01) begin
                instr_reg <= data;
                src_flag  <= 2'b01;
                ins       <= data[7:5];
                ad1       <= data[4:0];
                ad2       <= 8'd0;
            end else if (fetch == 2'b10) begin
                instr_reg <= data;
                src_flag  <= 2'b10;
                ins       <= 3'd0;
                ad1       <= 5'd0;
                ad2       <= data;
            end else begin
                // No fetch update, retain outputs based on current src_flag
                if (src_flag == 2'b01) begin
                    ins <= instr_reg[7:5];
                    ad1 <= instr_reg[4:0];
                    ad2 <= 8'd0;
                end else if (src_flag == 2'b10) begin
                    ins <= 3'd0;
                    ad1 <= 5'd0;
                    ad2 <= instr_reg;
                end else begin
                    ins <= 3'd0;
                    ad1 <= 5'd0;
                    ad2 <= 8'd0;
                end
            end
        end
    end

endmodule