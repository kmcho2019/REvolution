module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    // Internal registers implemented as wires with clocked assignments
    wire [7:0] ins_p1;
    wire [7:0] ins_p2;

    // Register update logic using continuous assignments
    assign ins_p1 = (!rst) ? 8'b0 : 
                   (fetch == 2'b01) ? data : ins_p1;
    
    assign ins_p2 = (!rst) ? 8'b0 : 
                   (fetch == 2'b10) ? data : ins_p2;

    // Clock the assignments
    reg [7:0] ins_p1_reg;
    reg [7:0] ins_p2_reg;
    always @(posedge clk) begin
        ins_p1_reg <= ins_p1;
        ins_p2_reg <= ins_p2;
    end

    // Direct output assignments
    assign ins = ins_p1_reg[7:5];
    assign ad1 = ins_p1_reg[4:0];
    assign ad2 = ins_p2_reg;

endmodule