module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Internal registers to store instructions from different sources
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Register updates using continuous assignments with clock edge detection
    wire [7:0] next_ins_p1 = (!rst) ? 8'b0 : (fetch == 2'b01) ? data : ins_p1;
    wire [7:0] next_ins_p2 = (!rst) ? 8'b0 : (fetch == 2'b10) ? data : ins_p2;

    // Update registers on clock edges
    always @(posedge clk) begin
        ins_p1 <= next_ins_p1;
        ins_p2 <= next_ins_p2;
    end

    // Continuous assignments for outputs (same as original)
    assign ins = ins_p1[7:5];  // High 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];  // Low 5 bits of ins_p1
    assign ad2 = ins_p2;       // Full ins_p2 value

endmodule