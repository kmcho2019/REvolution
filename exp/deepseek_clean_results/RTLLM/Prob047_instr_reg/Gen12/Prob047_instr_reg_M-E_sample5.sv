module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Shadow register hierarchy
    reg [7:0] speculative_p1, speculative_p2;
    reg [7:0] confirmed_p1, confirmed_p2;
    reg spec_valid_p1, spec_valid_p2;
    
    // Pipeline stages
    reg [1:0] fetch_stage1, fetch_stage2;
    reg [7:0] data_stage1, data_stage2;
    
    // Always speculate - stage 1
    always @(posedge clk) begin
        if (!rst) begin
            {speculative_p1, speculative_p2} <= 0;
            {spec_valid_p1, spec_valid_p2} <= 0;
            {confirmed_p1, confirmed_p2} <= 0;
            {fetch_stage1, fetch_stage2} <= 0;
            {data_stage1, data_stage2} <= 0;
        end else begin
            // Pipeline movement
            fetch_stage2 <= fetch_stage1;
            fetch_stage1 <= fetch;
            data_stage2 <= data_stage1;
            data_stage1 <= data;
            
            // Speculative capture (always)
            speculative_p1 <= data;
            speculative_p2 <= data;
            spec_valid_p1 <= (fetch == 2'b01);
            spec_valid_p2 <= (fetch == 2'b10);
            
            // Confirmed capture (when fetch matches)
            if (fetch_stage2 == 2'b01) confirmed_p1 <= data_stage2;
            if (fetch_stage2 == 2'b10) confirmed_p2 <= data_stage2;
        end
    end
    
    // Output selection - prefer confirmed, fallback to speculative
    always @(*) begin
        ins = confirmed_p1[7:5];
        ad1 = confirmed_p1[4:0];
        ad2 = confirmed_p2;
        
        if (!spec_valid_p1) begin
            ins = speculative_p1[7:5];
            ad1 = speculative_p1[4:0];
        end
        
        if (!spec_valid_p2) begin
            ad2 = speculative_p2;
        end
    end

endmodule