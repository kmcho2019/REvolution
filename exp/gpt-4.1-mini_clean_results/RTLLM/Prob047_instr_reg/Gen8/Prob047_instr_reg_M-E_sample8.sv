module instr_reg (
    input  wire        clk,
    input  wire        rst,    // Active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    wire update_p1 = (fetch == 2'b01);
    wire update_p2 = (fetch == 2'b10);
    wire enable   = update_p1 | update_p2;

    // Synchronous active-low reset and instruction registers update
    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else if (enable) begin
            if (update_p1)
                ins_p1 <= data;
            if (update_p2)
                ins_p2 <= data;
        end
        // else retain previous values
    end

    // Outputs derived from stored instructions
    assign ins = ins_p1[7:5];   // High 3 bits from ins_p1
    assign ad1 = ins_p1[4:0];   // Low 5 bits from ins_p1
    assign ad2 = ins_p2;        // Full 8 bits from ins_p2

endmodule