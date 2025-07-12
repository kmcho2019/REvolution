module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Main storage registers (optimized to store only needed bits)
    reg [7:0] ins_p1;  // Full storage needed for both fields
    reg [7:0] ins_p2;

    // Pipeline control signals
    wire p1_valid = fetch[0];
    wire p2_valid = fetch[1];

    // Dual-edge capture logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
        end else if (p1_valid) begin
            ins_p1 <= data;
        end
    end

    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 8'b0;
        end else if (p2_valid) begin
            ins_p2 <= data;
        end
    end

    // Clock-gated pipeline registers
    wire output_update = p1_valid | p2_valid;
    reg output_update_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            output_update_reg <= 1'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            output_update_reg <= output_update;
            if (output_update) begin
                ins <= ins_p1[7:5];
                ad1 <= ins_p1[4:0];
                ad2 <= ins_p2;
            end
        end
    end

endmodule