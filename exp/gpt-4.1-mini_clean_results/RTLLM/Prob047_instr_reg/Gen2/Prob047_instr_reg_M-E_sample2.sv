module instr_reg (
    input        clk,
    input        rst,           // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] instruction;
    reg [7:0] ins_p2_reg;
    reg       ins_p2_valid;

    // Write enable for instruction register
    wire write_en_ins_p1 = (fetch == 2'b01);
    wire write_en_ins_p2 = (fetch == 2'b10);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instruction <= 8'b0;
            ins_p2_reg <= 8'b0;
            ins_p2_valid <= 1'b0;
        end else begin
            // Latch instruction from source 1
            if (write_en_ins_p1) begin
                instruction <= data;
            end
            // Latch instruction from source 2 separately and flag valid
            if (write_en_ins_p2) begin
                ins_p2_reg <= data;
                ins_p2_valid <= 1'b1;
            end
            // If fetch is neither 01 nor 10, retain previous values
        end
    end

    // Output decoding:
    // ins and ad1 extracted from instruction (source 1)
    assign ins = instruction[7:5];
    assign ad1 = instruction[4:0];
    // ad2 outputs the last valid ins_p2 data; zero if never valid after reset
    assign ad2 = ins_p2_valid ? ins_p2_reg : 8'b0;

endmodule