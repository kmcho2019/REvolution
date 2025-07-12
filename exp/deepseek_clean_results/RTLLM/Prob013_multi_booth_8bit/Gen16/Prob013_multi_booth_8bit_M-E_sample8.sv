module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_pp [0:3];
    reg [15:0] stage1_sum;
    reg [15:0] stage1_carry;
    reg [2:0] stage1_ctr;
    reg stage1_active;
    
    // Main computation
    always @(posedge clk) begin
        if (reset) begin
            // Initialize pipeline
            p <= 16'b0;
            stage1_sum <= 16'b0;
            stage1_carry <= 16'b0;
            stage1_ctr <= 3'b0;
            stage1_active <= 1'b1;
            rdy <= 1'b0;
            
            // Generate all partial products in parallel
            for (integer i = 0; i < 4; i = i + 1) begin
                case (b[2*i+1:2*i])
                    2'b01: stage1_pp[i] <= {{8{a[7]}}, a} << (2*i);
                    2'b10: stage1_pp[i] <= ~({{8{a[7]}}, a} << (2*i)) + 1;
                    2'b11: stage1_pp[i] <= ~({{8{a[7]}}, a} << (2*i+1)) + 1;
                    default: stage1_pp[i] <= 16'b0; // 00 or invalid
                endcase
            end
        end else begin
            if (stage1_active) begin
                // Carry-save addition of partial products
                case (stage1_ctr)
                    0: begin
                        {stage1_carry, stage1_sum} <= 
                            stage1_pp[0] + stage1_pp[1];
                    end
                    1: begin
                        {stage1_carry, stage1_sum} <= 
                            {stage1_carry[14:0], 1'b0} + stage1_sum + stage1_pp[2];
                    end
                    2: begin
                        {stage1_carry, stage1_sum} <= 
                            {stage1_carry[14:0], 1'b0} + stage1_sum + stage1_pp[3];
                    end
                    3: begin
                        // Final addition
                        p <= stage1_sum + {stage1_carry[14:0], 1'b0};
                        stage1_active <= 1'b0;
                        rdy <= 1'b1;
                    end
                endcase
                stage1_ctr <= stage1_ctr + 1;
            end
        end
    end

endmodule