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
    reg p1_updated, p2_updated;

    // Sequential logic for instruction storage
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            p1_updated <= 1'b0;
            p2_updated <= 1'b0;
        end
        else begin
            p1_updated <= 1'b0;
            p2_updated <= 1'b0;
            
            case (fetch)
                2'b01: begin
                    ins_p1 <= data;
                    p1_updated <= 1'b1;
                end
                2'b10: begin
                    ins_p2 <= data;
                    p2_updated <= 1'b1;
                end
                // default: no update needed
            endcase
        end
    end

    // Registered outputs with enable signals
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            if (p1_updated) begin
                ins <= ins_p1[7:5];
                ad1 <= ins_p1[4:0];
            end
            if (p2_updated) begin
                ad2 <= ins_p2;
            end
        end
    end

endmodule