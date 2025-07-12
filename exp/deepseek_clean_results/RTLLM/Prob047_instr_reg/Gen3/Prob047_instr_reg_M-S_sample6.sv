module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            if (fetch == 2'b01) begin
                ins <= data[7:5];
                ad1 <= data[4:0];
            end
            if (fetch == 2'b10) begin
                ad2 <= data;
            end
        end
    end

endmodule