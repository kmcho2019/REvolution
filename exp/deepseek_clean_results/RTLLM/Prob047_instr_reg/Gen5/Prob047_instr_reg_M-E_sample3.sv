module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline stage 1 signals
    reg [1:0] fetch_stage1;
    reg [7:0] data_stage1;
    wire fetch_valid = |fetch;  // Any fetch signal active
    
    // Shadow registers with clock gating
    reg [7:0] ins_p1 = 0;
    reg [7:0] ins_p2 = 0;
    wire clk_gated = clk & fetch_valid;  // Simple clock gating
    
    // Priority encoded write enables
    wire write_p1 = (fetch == 2'b01);
    wire write_p2 = (fetch == 2'b10);
    
    // Pipeline stage 1: Capture inputs
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            fetch_stage1 <= 2'b00;
            data_stage1 <= 8'b0;
        end else begin
            fetch_stage1 <= fetch;
            data_stage1 <= data;
        end
    end
    
    // Pipeline stage 2: Update registers (clock gated)
    always @(posedge clk_gated or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
        end else begin
            if (write_p1) ins_p1 <= data_stage1;
            if (write_p2) ins_p2 <= data_stage1;
        end
    end
    
    // Output stage (registered for better timing)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule