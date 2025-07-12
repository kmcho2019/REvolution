module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
            if (fetch == 2'b10) begin
                ins_p2 <= data;
            end
            // If fetch is neither 2'b01 nor 2'b10, retain previous values
        end
    end

    assign ins = ins_p1[7:5];   // High 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];   // Low 5 bits of ins_p1
    assign ad2 = ins_p2;        // Full 8 bits from ins_p2

endmodule