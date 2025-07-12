module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    parameter WIDTH = 8;
    parameter OP_WIDTH = 3;
    parameter ADDR_WIDTH = 5;

    reg [WIDTH-1:0] ins_p1, ins_p2;
    reg [WIDTH-1:0] ins_p1_q, ins_p2_q;
    wire clk_gated = clk & (|fetch);  // Clock gating

    // Rising edge processing for ins_p1
    always @(posedge clk_gated or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p1_q <= 0;
        end else if (fetch[0]) begin
            ins_p1 <= data;
            ins_p1_q <= ins_p1;  // Pipeline stage
        end
    end

    // Falling edge processing for ins_p2
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 0;
            ins_p2_q <= 0;
        end else if (fetch[1]) begin
            ins_p2 <= data;
            ins_p2_q <= ins_p2;  // Pipeline stage
        end
    end

    // Output latching with bypass
    always @(*) begin
        if (fetch[0]) begin  // Bypass path
            {ins, ad1} = data;
        end else begin
            {ins, ad1} = ins_p1_q;
        end
        
        if (fetch[1]) begin  // Bypass path
            ad2 = data;
        end else begin
            ad2 = ins_p2_q;
        end
    end

endmodule