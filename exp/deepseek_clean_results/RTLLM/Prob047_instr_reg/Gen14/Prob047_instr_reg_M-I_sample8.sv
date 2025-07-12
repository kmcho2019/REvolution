module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    wire p1_update, p2_update;

    // Clock gating control
    assign p1_update = fetch[0];
    assign p2_update = fetch[1];

    always @(posedge clk) begin
        if (rst) begin
            // Synchronous register updates with clock gating
            if (p1_update) ins_p1 <= data;
            if (p2_update) ins_p2 <= data;
        end else begin
            // Synchronous reset
            ins_p1 <= 0;
            ins_p2 <= 0;
        end

        // Registered outputs for better timing
        {ins, ad1} <= ins_p1;
        ad2 <= ins_p2;
    end

endmodule