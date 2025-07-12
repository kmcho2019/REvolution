module instr_reg (
    input wire clk,
    input wire rst,          // Active low synchronous reset
    input wire [1:0] fetch,  // Source selector: 01=ins_p1 load, 10=ins_p2 load
    input wire [7:0] data,
    output wire [2:0] ins,   // opcode from ins_p1[7:5]
    output wire [4:0] ad1,   // reg addr from ins_p1[4:0]
    output wire [7:0] ad2    // full data from ins_p2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            // Load ins_p1 if fetch indicates source 01
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
            // Load ins_p2 if fetch indicates source 10
            if (fetch == 2'b10) begin
                ins_p2 <= data;
            end
            // If fetch neither 01 nor 10, retain both registers
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule