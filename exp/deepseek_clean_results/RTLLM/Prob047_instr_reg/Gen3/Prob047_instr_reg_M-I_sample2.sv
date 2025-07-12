module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers to store instructions from different sources
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Active low reset clears all registers
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            // Update input registers based on fetch signal
            case (fetch)
                2'b01: begin
                    ins_p1 <= data;
                    // Update outputs when ins_p1 changes
                    ins <= data[7:5];
                    ad1 <= data[4:0];
                end
                2'b10: begin
                    ins_p2 <= data;
                    // Update ad2 when ins_p2 changes
                    ad2 <= data;
                end
                default: begin
                    // Retain previous values
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

endmodule