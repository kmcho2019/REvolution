module instr_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] fetch,
    input wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [7:0] instruction_reg;
    reg [1:0] source_state; // 2'b01 for source 1, 2'b10 for source 2, 2'b00 for none/reset

    always @(posedge clk) begin
        if (!rst) begin
            instruction_reg <= 8'b0;
            source_state <= 2'b00;
        end else begin
            if (fetch == 2'b01) begin
                instruction_reg <= data;
                source_state <= 2'b01;
            end else if (fetch == 2'b10) begin
                instruction_reg <= data;
                source_state <= 2'b10;
            end
            // if fetch is neither, retain previous values
        end
    end

    // Output logic:
    // For fetch=01: ins and ad1 from instruction_reg
    assign ins = (source_state == 2'b01) ? instruction_reg[7:5] : 3'b000;
    assign ad1 = (source_state == 2'b01) ? instruction_reg[4:0] : 5'b00000;
    // For fetch=10: ad2 from instruction_reg, else zero
    assign ad2 = (source_state == 2'b10) ? instruction_reg : 8'b0;

endmodule