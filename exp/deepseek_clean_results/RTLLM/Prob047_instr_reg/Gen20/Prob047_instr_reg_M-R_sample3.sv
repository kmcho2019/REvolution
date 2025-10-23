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
        p1_en = (fetch == 2'b01);
        p2_en = (fetch == 2'b10);
    end

    // Register updates
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            case (1'b1)
                p1_en: ins_p1 <= data;
                p2_en: ins_p2 <= data;
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    // Output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule