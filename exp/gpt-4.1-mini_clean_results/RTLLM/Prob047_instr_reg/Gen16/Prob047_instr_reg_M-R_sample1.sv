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

    // Register ins_p1 loads data when fetch == 2'b01
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
        end else if (fetch == 2'b01) begin
            ins_p1 <= data;
        end
    end

    // Register ins_p2 loads data when fetch == 2'b10
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 8'b0;
        end else if (fetch == 2'b10) begin
            ins_p2 <= data;
        end
    end

    // Outputs derived from ins_p1 and ins_p2 registers
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule