module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    reg p1_en, p2_en;

    // Decode fetch signals
    always @(*) begin
        case (fetch)
            2'b01: begin p1_en = 1; p2_en = 0; end
            2'b10: begin p1_en = 0; p2_en = 1; end
            default: begin p1_en = 0; p2_en = 0; end
        endcase
    end

    // Register updates with explicit enables
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
        end else begin
            if (p1_en) ins_p1 <= data;
            if (p2_en) ins_p2 <= data;
        end
    end

    // Direct output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule