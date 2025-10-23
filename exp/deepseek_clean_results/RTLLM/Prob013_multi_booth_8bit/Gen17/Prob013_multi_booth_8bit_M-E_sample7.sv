module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_pp;   // Stage 1 partial product
    reg [15:0] stage1_acc;  // Stage 1 accumulator
    reg [7:0] stage1_mult;  // Stage 1 multiplier
    reg [1:0] stage1_ctr;   // Stage 1 counter
    reg stage1_active;      // Stage 1 active flag
    
    // Main registers
    reg [15:0] acc;         // Accumulator
    reg [7:0] multiplier;   // Multiplier
    reg [15:0] multiplicand; // Multiplicand
    reg [1:0] ctr;          // Counter
    reg done;               // Done flag
    
    // Combinational signals
    wire [2:0] booth_bits;
    wire [15:0] pp;
    wire early_term;
    wire [1:0] shift_amt;
    
    // Booth encoding bits
    assign booth_bits = (ctr == 0) ? {multiplier[1:0], 1'b0} : 
                       {multiplier[ctr*2+1:ctr*2], multiplier[ctr*2-1]};
    
    // Partial product generation
    assign pp = (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
               (booth_bits == 3'b011) ? (multiplicand << 1) :
               (booth_bits == 3'b100) ? -(multiplicand << 1) :
               (booth_bits == 3'b101 || booth_bits == 3'b110) ? -multiplicand :
               16'b0;
    
    // Early termination detection
    assign early_term = (multiplier == 0 || (&multiplier)) && (ctr != 0);
    
    // Dynamic shift amount based on leading zeros/ones
    assign shift_amt = (early_term) ? 2'b00 : 
                      (multiplier[7:6] == 2'b00 || multiplier[7:6] == 2'b11) ? 2'b10 : 
                      2'b01;
    
    // Pipeline stage 1 (Booth encoding)
    always @(posedge clk) begin
        if (reset) begin
            stage1_pp <= 16'b0;
            stage1_acc <= 16'b0;
            stage1_mult <= 8'b0;
            stage1_ctr <= 2'b0;
            stage1_active <= 1'b0;
        end else if (!done) begin
            stage1_pp <= pp;
            stage1_acc <= acc;
            stage1_mult <= multiplier;
            stage1_ctr <= ctr;
            stage1_active <= 1'b1;
        end else begin
            stage1_active <= 1'b0;
        end
    end
    
    // Pipeline stage 2 (Accumulation)
    always @(posedge clk) begin
        if (reset) begin
            acc <= 16'b0;
            multiplier <= 8'b0;
            multiplicand <= 16'b0;
            ctr <= 2'b0;
            done <= 1'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            if (stage1_active) begin
                // Accumulate partial product
                acc <= stage1_acc + stage1_pp;
                
                // Update multiplier with dynamic shift
                multiplier <= stage1_mult >> shift_amt;
                
                // Update counter or finish
                if (early_term || stage1_ctr == 2'b11) begin
                    done <= 1'b1;
                    p <= stage1_acc + stage1_pp;
                    rdy <= 1'b1;
                end else begin
                    ctr <= stage1_ctr + 1;
                end
            end else if (!done) begin
                // Initial load
                acc <= 16'b0;
                multiplier <= b;
                multiplicand <= {{8{a[7]}}, a};
                ctr <= 2'b0;
                done <= 1'b0;
            end
        end
    end

endmodule