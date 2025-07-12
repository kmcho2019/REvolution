module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Primary and shadow registers with different reset behaviors
    reg [7:0] ins_p1_primary, ins_p1_shadow;
    reg [7:0] ins_p2_primary, ins_p2_shadow;
    
    // Pipeline registers for outputs
    reg [2:0] ins_pipe;
    reg [4:0] ad1_pipe;
    reg [7:0] ad2_pipe;
    
    // Clock gating and validation signals
    wire valid_fetch = (fetch == 2'b01) || (fetch == 2'b10);
    wire p1_update = valid_fetch & (fetch == 2'b01);
    wire p2_update = valid_fetch & (fetch == 2'b10);
    
    // Shadow buffer management
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Full reset for primary buffers
            ins_p1_primary <= 8'b0;
            ins_p2_primary <= 8'b0;
            
            // Partial reset for shadow buffers (preserve LSBs)
            ins_p1_shadow <= {8{rst}};
            ins_p2_shadow <= {8{rst}};
        end
        else begin
            // Primary buffer updates
            if (p1_update) ins_p1_primary <= data;
            if (p2_update) ins_p2_primary <= data;
            
            // Shadow buffer speculative updates
            ins_p1_shadow <= ins_p1_primary;
            ins_p2_shadow <= ins_p2_primary;
        end
    end
    
    // Output pipeline stage
    always @(posedge clk) begin
        if (!rst) begin
            ins_pipe <= 3'b0;
            ad1_pipe <= 5'b0;
            ad2_pipe <= 8'b0;
        end
        else begin
            // Operand isolation - only update when needed
            if (valid_fetch) begin
                ins_pipe <= ins_p1_primary[7:5];
                ad1_pipe <= ins_p1_primary[4:0];
                ad2_pipe <= ins_p2_primary;
            end
        end
    end
    
    // Final output assignments
    always @(*) begin
        ins = ins_pipe;
        ad1 = ad1_pipe;
        ad2 = ad2_pipe;
    end

endmodule