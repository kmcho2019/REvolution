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

    // Clock gating enable signals
    wire load_p1 = (fetch == 2'b01);
    wire load_p2 = (fetch == 2'b10);

    // Simple clock gating cells (could be replaced with dedicated gating cell in ASIC)
    wire gated_clk_p1 = clk & load_p1;
    wire gated_clk_p2 = clk & load_p2;

    // ins_p1 register, loads only on load_p1 with synchronous reset
    always @(posedge gated_clk_p1) begin
        if (rst)
            ins_p1 <= 8'b0;
        else
            ins_p1 <= data;
    end

    // ins_p2 register, loads only on load_p2 with synchronous reset
    always @(posedge gated_clk_p2) begin
        if (rst)
            ins_p2 <= 8'b0;
        else
            ins_p2 <= data;
    end

    // Synchronous reset when no load (to clear when reset asserted)
    always @(posedge clk) begin
        if (rst) begin
            // If reset asserted and no load, clear registers
            if (!load_p1)
                ins_p1 <= 8'b0;
            if (!load_p2)
                ins_p2 <= 8'b0;
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule