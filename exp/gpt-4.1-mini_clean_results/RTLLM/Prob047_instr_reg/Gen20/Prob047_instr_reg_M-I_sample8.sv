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

    // Write enable signals for registers to reduce toggling
    wire we_p1 = (fetch == 2'b01);
    wire we_p2 = (fetch == 2'b10);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (we_p1) begin
                ins_p1 <= data;
            end
            if (we_p2) begin
                ins_p2 <= data;
            end
            // if neither we_p1 nor we_p2, retain previous values
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule