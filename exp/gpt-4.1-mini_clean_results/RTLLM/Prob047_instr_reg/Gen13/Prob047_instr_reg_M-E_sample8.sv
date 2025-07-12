module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            case (fetch)
                2'b01: ins_p1 <= data;  // From register source
                2'b10: ins_p2 <= data;  // From RAM/ROM source
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    assign ins = ins_p1[7:5];    // opcode from ins_p1
    assign ad1 = ins_p1[4:0];    // register address from ins_p1
    assign ad2 = ins_p2;         // full 8-bit data from ins_p2

endmodule