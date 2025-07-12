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
    reg [7:0] ins_p1_q, ins_p2_q;

    // Dual-edge triggered register updates
    always @(posedge clk or negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            case (fetch)
                2'b01: ins_p1 <= data;  // Update only p1
                2'b10: ins_p2 <= data;  // Update only p2
                default: begin         // Hold current values
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    // Output pipeline stage
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule