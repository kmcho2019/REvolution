module instr_reg (
    input  wire        clk,
    input  wire        rst,       // active low reset (synchronous)
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    // Combined 16-bit register: upper 8 bits hold ins_p1, lower 8 bits hold ins_p2
    reg [15:0] instr_combined;

    always @(posedge clk) begin
        if (!rst) begin
            instr_combined <= 16'b0;
        end else begin
            case (fetch)
                2'b01: instr_combined <= {data, instr_combined[7:0]};  // update upper 8 bits (ins_p1)
                2'b10: instr_combined <= {instr_combined[15:8], data}; // update lower 8 bits (ins_p2)
                default: instr_combined <= instr_combined;             // hold previous
            endcase
        end
    end

    // Extract fields from instr_combined
    wire [7:0] ins_p1 = instr_combined[15:8];
    wire [7:0] ins_p2 = instr_combined[7:0];

    assign ins = ins_p1[7:5];  // High 3 bits of ins_p1 (opcode)
    assign ad1 = ins_p1[4:0];  // Low 5 bits of ins_p1 (register address)
    assign ad2 = ins_p2;       // Full 8 bits from ins_p2

endmodule