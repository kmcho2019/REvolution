module instr_reg (
    input wire clk,
    input wire rst,          // Active low reset
    input wire [1:0] fetch,  // 2'b01 for ins_p1 update, 2'b10 for ins_p2 update
    input wire [7:0] data,

    output wire [2:0] ins,   // High 3 bits of ins_p1
    output wire [4:0] ad1,   // Low 5 bits of ins_p1
    output wire [7:0] ad2    // Full ins_p2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            case (fetch)
                2'b01: ins_p1 <= data;
                2'b10: ins_p2 <= data;
                default: begin
                    // retain current values
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule