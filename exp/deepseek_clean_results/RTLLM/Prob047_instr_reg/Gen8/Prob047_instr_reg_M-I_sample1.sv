module instr_reg #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 3,
    parameter ADDR_WIDTH = 5
)(
    input clk,
    input rst,
    input [1:0] fetch,
    input [DATA_WIDTH-1:0] data,
    output [OPCODE_WIDTH-1:0] ins,
    output [ADDR_WIDTH-1:0] ad1,
    output [DATA_WIDTH-1:0] ad2
);

    reg [DATA_WIDTH-1:0] ins_p1, ins_p2;
    wire p1_en = (fetch == 2'b01);
    wire p2_en = (fetch == 2'b10);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= {DATA_WIDTH{1'b0}};
            ins_p2 <= {DATA_WIDTH{1'b0}};
        end
        else begin
            // Simplified update logic without redundant holds
            if (p1_en) ins_p1 <= data;
            if (p2_en) ins_p2 <= data;
        end
    end

    // Direct output assignments for optimal timing
    assign ins = ins_p1[DATA_WIDTH-1:DATA_WIDTH-OPCODE_WIDTH];
    assign ad1 = ins_p1[ADDR_WIDTH-1:0];
    assign ad2 = ins_p2;

endmodule