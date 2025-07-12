module instr_reg(
    input        clk,
    input        rst,    // synchronous active-high reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    wire load_p1, load_p2;

    assign load_p1 = (fetch == 2'b01);
    assign load_p2 = (fetch == 2'b10);

    // Simple clock gating to prevent register toggling when no load
    wire gated_clk_p1 = clk & load_p1;
    wire gated_clk_p2 = clk & load_p2;

    // However, synthesis tools typically do not support gated clocks well.
    // Instead, implement clock enable style to avoid gated clocks:

    always @(posedge clk) begin
        if (rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (load_p1)
                ins_p1 <= data;
            if (load_p2)
                ins_p2 <= data;
        end
    end

    assign ins = ins_p1[7:5];   // high 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];   // low 5 bits of ins_p1
    assign ad2 = ins_p2;        // full 8 bits of ins_p2

endmodule