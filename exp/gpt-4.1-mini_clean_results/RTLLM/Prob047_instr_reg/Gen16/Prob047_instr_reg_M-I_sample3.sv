module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] instr;
    reg       src_flag;       // 0: fetch=2'b01, 1: fetch=2'b10
    reg [1:0] last_fetch;

    // Sequential block to update instr and src_flag only when fetch changes and is valid
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr      <= 8'b0;
            src_flag   <= 1'b0;
            last_fetch <= 2'b00;
        end else begin
            if ((fetch == 2'b01 || fetch == 2'b10) && (fetch != last_fetch || data != instr)) begin
                instr      <= data;
                src_flag   <= (fetch == 2'b10) ? 1'b1 : 1'b0;
                last_fetch <= fetch;
            end else begin
                // retain previous values if no valid fetch or fetch/data unchanged
                instr      <= instr;
                src_flag   <= src_flag;
                last_fetch <= last_fetch;
            end
        end
    end

    // Register outputs to improve timing; outputs updated on clk and reset
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b000;
            ad1 <= 5'b00000;
            ad2 <= 8'b00000000;
        end else begin
            if (src_flag == 1'b0) begin
                ins <= instr[7:5];
                ad1 <= instr[4:0];
                ad2 <= 8'b00000000;
            end else begin
                ins <= 3'b000;
                ad1 <= 5'b00000;
                ad2 <= instr;
            end
        end
    end

endmodule