module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers with parity bits
    reg [8:0] ins_p1;  // [7:0] data + [8] parity
    reg [8:0] ins_p2;
    
    // Output staging registers
    reg [2:0] ins_reg;
    reg [4:0] ad1_reg;
    reg [7:0] ad2_reg;
    
    // Clock gating signals
    wire p1_update = fetch[0] & ~fetch[1];
    wire p2_update = fetch[1] & ~fetch[0];
    wire outputs_update = |fetch;
    
    // Calculate parity (odd parity)
    wire data_parity = ^data;
    
    // Input capture on both edges
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 9'b0;
        end else if (p1_update) begin
            ins_p1 <= {data_parity, data};
        end
    end
    
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 9'b0;
        end else if (p2_update) begin
            ins_p2 <= {data_parity, data};
        end
    end
    
    // Output staging with clock gating
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {ins, ad1, ad2} <= 16'b0;
        end else if (outputs_update) begin
            // Check parity before updating outputs
            if (^ins_p1 == 1'b1) begin
                ins <= ins_p1[7:5];
                ad1 <= ins_p1[4:0];
            end
            if (^ins_p2 == 1'b1) begin
                ad2 <= ins_p2[7:0];
            end
        end
    end

endmodule