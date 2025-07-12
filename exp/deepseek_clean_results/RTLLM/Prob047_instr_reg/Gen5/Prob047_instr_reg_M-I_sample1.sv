module instr_reg (
    input clk,
    input rst_n,  // Active low reset
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    parameter RESET_VAL = 1'b0;
    
    reg [7:0] ins_p1, ins_p2;
    reg ins_p1_en, ins_p2_en;

    // Clock gating control
    always @(*) begin
        ins_p1_en = fetch[0];
        ins_p2_en = fetch[1];
    end

    // Synchronous reset and register updates
    always @(posedge clk) begin
        if (!rst_n) begin
            ins_p1 <= {8{RESET_VAL}};
            ins_p2 <= {8{RESET_VAL}};
        end else begin
            if (ins_p1_en) ins_p1 <= data;
            if (ins_p2_en) ins_p2 <= data;
        end
    end

    // Direct output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule