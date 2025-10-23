module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stages
    localparam DECODE = 2'b00;
    localparam ACCUM = 2'b01;
    localparam FINAL = 2'b10;
    
    reg [1:0] stage;
    reg [4:0] ctr;  // 5-bit counter for 16 steps
    reg [15:0] multiplicand;
    reg [16:0] multiplier; // Extended for sign
    
    // Pipeline registers
    reg [15:0] pp0, pp1, pp2, pp3;
    reg [15:0] sum_stage, carry_stage;
    reg [15:0] final_sum;
    
    // Booth encoders (4 parallel)
    wire [2:0] booth0 = {multiplier[1:0], (ctr==0) ? 1'b0 : multiplier[2]};
    wire [2:0] booth1 = {multiplier[3:2], multiplier[1]};
    wire [2:0] booth2 = {multiplier[5:4], multiplier[3]};
    wire [2:0] booth3 = {multiplier[7:6], multiplier[5]};
    
    // Partial product generators
    wire [15:0] m_neg = -multiplicand;
    wire [15:0] m_neg2 = -{multiplicand[14:0], 1'b0};
    wire [15:0] m_pos2 = {multiplicand[14:0], 1'b0};
    
    function [15:0] booth_pp;
        input [2:0] enc;
        begin
            case (enc)
                3'b000, 3'b111: booth_pp = 16'b0;
                3'b001, 3'b010: booth_pp = multiplicand;
                3'b011: booth_pp = m_pos2;
                3'b100: booth_pp = m_neg2;
                3'b101, 3'b110: booth_pp = m_neg;
                default: booth_pp = 16'b0;
            endcase
        end
    endfunction
    
    // Carry-save adder
    function [15:0] csa_sum;
        input [15:0] a, b, c;
        begin
            csa_sum = a ^ b ^ c;
        end
    endfunction
    
    function [15:0] csa_carry;
        input [15:0] a, b, c;
        begin
            csa_carry = ((a & b) | (a & c) | (b & c)) << 1;
        end
    endfunction
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= DECODE;
            ctr <= 5'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{9{b[7]}}, b};
            p <= 16'b0;
            rdy <= 1'b0;
            sum_stage <= 16'b0;
            carry_stage <= 16'b0;
        end else begin
            case (stage)
                DECODE: begin
                    // Generate 4 partial products in parallel
                    pp0 <= booth_pp(booth0);
                    pp1 <= booth_pp(booth1) << 2;
                    pp2 <= booth_pp(booth2) << 4;
                    pp3 <= booth_pp(booth3) << 6;
                    
                    stage <= ACCUM;
                end
                
                ACCUM: begin
                    // First level CSA
                    sum_stage <= csa_sum(pp0, pp1, pp2);
                    carry_stage <= csa_carry(pp0, pp1, pp2);
                    
                    // Second level CSA with pp3
                    final_sum <= csa_sum(sum_stage, carry_stage, pp3) + 
                                csa_carry(sum_stage, carry_stage, pp3);
                    
                    stage <= FINAL;
                end
                
                FINAL: begin
                    // Accumulate result and shift multiplier
                    p <= p + final_sum;
                    multiplier <= {multiplier[16], multiplier[16:2]}; // Radix-4 shift
                    
                    ctr <= ctr + 1;
                    if (ctr == 15) begin
                        rdy <= 1'b1;
                        stage <= DECODE;
                    end else begin
                        stage <= DECODE;
                    end
                end
            endcase
        end
    end
    
    // Early termination detection
    always @(*) begin
        if (multiplier[16:8] == {9{multiplier[16]}}) begin
            // All remaining bits are sign bits
            if (stage == FINAL) begin
                rdy = 1'b1;
            end
        end
    end

endmodule