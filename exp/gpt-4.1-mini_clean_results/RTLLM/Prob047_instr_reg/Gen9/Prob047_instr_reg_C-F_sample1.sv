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

    wire wr_ins_p1 = (fetch == 2'b01);
    wire wr_ins_p2 = (fetch == 2'b10);

    // Synchronous active-low reset with clock enable style update for power optimization
    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (wr_ins_p1)
                ins_p1 <= data;
            if (wr_ins_p2)
                ins_p2 <= data;
            // else retain previous values, no update
        end
    end

    // Output assignments derived from stored instructions
    assign ins = ins_p1[7:5];  // high 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];  // low 5 bits of ins_p1
    assign ad2 = ins_p2;       // full 8 bits from ins_p2

endmodule