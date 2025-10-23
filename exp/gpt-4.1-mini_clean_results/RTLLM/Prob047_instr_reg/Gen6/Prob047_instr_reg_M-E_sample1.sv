module instr_reg (
    input        clk,
    input        rst,           // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Synchronous reset and update for ins_p1
    always @(posedge clk) begin
        if (!rst)
            ins_p1 <= 8'b0;
        else if (fetch == 2'b01)
            ins_p1 <= data;
        else
            ins_p1 <= ins_p1;  // retain value explicitly
    end

    // Synchronous reset and update for ins_p2
    always @(posedge clk) begin
        if (!rst)
            ins_p2 <= 8'b0;
        else if (fetch == 2'b10)
            ins_p2 <= data;
        else
            ins_p2 <= ins_p2;  // retain value explicitly
    end

    // Output assignments
    assign ins = ins_p1[7:5];  // upper 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];  // lower 5 bits of ins_p1
    assign ad2 = ins_p2;       // full 8 bits of ins_p2

endmodule