module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers
    reg [7:0] ins_p1, ins_p2;

    // Single-edge capture logic with enables
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end else begin
            // Capture from source 1 (register)
            if (fetch == 2'b01) begin
                ins_p1 <= data;
                ins <= data[7:5];
                ad1 <= data[4:0];
            end
            // Capture from source 2 (RAM/ROM)
            if (fetch == 2'b10) begin
                ins_p2 <= data;
                ad2 <= data;
            end
        end
    end

endmodule