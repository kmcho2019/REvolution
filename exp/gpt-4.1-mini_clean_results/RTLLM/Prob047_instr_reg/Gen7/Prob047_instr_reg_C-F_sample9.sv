module instr_reg (
    input  wire        clk,
    input  wire        rst,       // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Single always block with asynchronous active-low reset
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b01) begin
                ins_p1 <= data;
                // ins_p2 unchanged
            end else if (fetch == 2'b10) begin
                ins_p2 <= data;
                // ins_p1 unchanged
            end
            // else retain previous values (no change)
        end
    end

    // Combinational output assignments
    assign ins = ins_p1[7:5];  // High 3 bits of ins_p1 (opcode)
    assign ad1 = ins_p1[4:0];  // Low 5 bits of ins_p1 (register address)
    assign ad2 = ins_p2;       // Full 8 bits from ins_p2

endmodule