module instr_reg (
    input  wire        clk,
    input  wire        rst,    // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            case (fetch)
                2'b01: ins_p1 <= data;    // Instruction from register source
                2'b10: ins_p2 <= data;    // Instruction from RAM/ROM source
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    // Output decoding as specified
    assign ins = ins_p1[7:5];   // High 3 bits of instruction from ins_p1
    assign ad1 = ins_p1[4:0];   // Low 5 bits of instruction from ins_p1
    assign ad2 = ins_p2;        // Full 8-bit instruction from ins_p2

endmodule