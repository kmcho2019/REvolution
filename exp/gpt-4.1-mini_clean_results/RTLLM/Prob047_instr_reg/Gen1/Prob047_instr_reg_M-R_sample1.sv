module instr_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] fetch,
    input wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Asynchronous reset for both registers
    always @(negedge rst or posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            // ins_p1 update logic
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
        end
    end

    // Separate always block for ins_p2 update with same reset
    always @(negedge rst or posedge clk) begin
        if (!rst) begin
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b10) begin
                ins_p2 <= data;
            end
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule