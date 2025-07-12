module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_p1;
    reg [7:0] stage1_p2;
    reg stage1_valid;
    reg fetch_error;

    // Pipeline stage 2 registers
    reg [7:0] stage2_p1;
    reg [7:0] stage2_p2;
    reg stage2_valid;

    // First pipeline stage: Instruction capture and validation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            stage1_p1 <= 8'b0;
            stage1_p2 <= 8'b0;
            stage1_valid <= 1'b0;
            fetch_error <= 1'b0;
        end
        else begin
            // Default assignments
            stage1_valid <= 1'b0;
            fetch_error <= 1'b0;

            case (fetch)
                2'b01: begin
                    stage1_p1 <= data;
                    stage1_p2 <= stage1_p2; // Maintain previous value
                    stage1_valid <= 1'b1;
                end
                2'b10: begin
                    stage1_p2 <= data;
                    stage1_p1 <= stage1_p1; // Maintain previous value
                    stage1_valid <= 1'b1;
                end
                2'b00: begin
                    // No operation - maintain previous values
                    stage1_p1 <= stage1_p1;
                    stage1_p2 <= stage1_p2;
                end
                default: begin
                    // Invalid fetch code detected
                    fetch_error <= 1'b1;
                    stage1_p1 <= 8'hFF; // Error pattern
                    stage1_p2 <= 8'hFF; // Error pattern
                end
            endcase
        end
    end

    // Second pipeline stage: Field separation and output registration
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            stage2_p1 <= 8'b0;
            stage2_p2 <= 8'b0;
            stage2_valid <= 1'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            // Register the pipeline stage
            stage2_p1 <= stage1_p1;
            stage2_p2 <= stage1_p2;
            stage2_valid <= stage1_valid;

            // Generate output fields
            ins <= stage1_p1[7:5];
            ad1 <= stage1_p1[4:0];
            ad2 <= stage1_p2;
        end
    end

endmodule