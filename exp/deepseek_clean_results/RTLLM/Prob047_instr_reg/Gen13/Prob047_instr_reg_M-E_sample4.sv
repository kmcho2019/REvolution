module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    reg [1:0] prev_fetch;

    // Input capture on rising edge
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            prev_fetch <= 2'b0;
        end else begin
            case (fetch)
                2'b01: ins_p1 <= data;
                2'b10: ins_p2 <= data;
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
            prev_fetch <= fetch;
        end
    end

    // Output update on falling edge (pipelined)
    always @(negedge clk) begin
        if (fetch != prev_fetch) begin  // Only update when fetch changes
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule