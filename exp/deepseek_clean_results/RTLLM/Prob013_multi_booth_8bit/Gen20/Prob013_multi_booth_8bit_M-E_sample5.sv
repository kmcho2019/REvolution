module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stage registers
    reg [15:0] mcand_even, mcand_odd;
    reg [2:0] booth_bits_even, booth_bits_odd;
    reg [15:0] sum, carry;
    reg [1:0] counter;
    reg stage_valid;
    
    // Zero/one detection
    wire zero_case = (a == 8'b0) || (b == 8'b0);
    wire one_case = (a == 8'b1) || (b == 8'b1);
    
    // Barrel shifter outputs
    wire [15:0] mcand_x2_even = mcand_even << 1;
    wire [15:0] mcand_x2_odd = mcand_odd << 1;
    
    // Booth encoding results
    wire [15:0] pp_even, pp_odd;
    
    // Even bits Booth encoding
    assign pp_even = 
        (booth_bits_even == 3'b001 || booth_bits_even == 3'b010) ? mcand_even :
        (booth_bits_even == 3'b011) ? mcand_x2_even :
        (booth_bits_even == 3'b100) ? ~mcand_x2_even + 1 :
        (booth_bits_even == 3'b101 || booth_bits_even == 3'b110) ? ~mcand_even + 1 :
        16'b0;
    
    // Odd bits Booth encoding
    assign pp_odd = 
        (booth_bits_odd == 3'b001 || booth_bits_odd == 3'b010) ? mcand_odd :
        (booth_bits_odd == 3'b011) ? mcand_x2_odd :
        (booth_bits_odd == 3'b100) ? ~mcand_x2_odd + 1 :
        (booth_bits_odd == 3'b101 || booth_bits_odd == 3'b110) ? ~mcand_odd + 1 :
        16'b0;
    
    // Carry-save adder
    wire [15:0] next_sum = pp_even ^ pp_odd ^ carry;
    wire [15:0] next_carry = {pp_even[14:0] & pp_odd[14:0] | 
                             pp_even[14:0] & carry[14:0] | 
                             pp_odd[14:0] & carry[14:0], 1'b0};
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            mcand_even <= {{8{a[7]}}, a};
            mcand_odd <= {{8{a[7]}}, a} << 1;
            booth_bits_even <= {b[1:0], 1'b0};
            booth_bits_odd <= {b[3:2], b[1]};
            sum <= 16'b0;
            carry <= 16'b0;
            counter <= 2'b0;
            stage_valid <= ~(zero_case || one_case);
            rdy <= zero_case || one_case;
            p <= zero_case ? 16'b0 : 
                 (a == 8'b1) ? {{8{b[7]}}, b} : 
                 {{8{a[7]}}, a};
        end
        else if (!rdy) begin
            // Pipeline stage 1: Update multiplicands and Booth bits
            mcand_even <= mcand_even << 2;
            mcand_odd <= mcand_odd << 2;
            booth_bits_even <= {b[counter*4+3], b[counter*4+2], b[counter*4+1]};
            booth_bits_odd <= {b[counter*4+5], b[counter*4+4], b[counter*4+3]};
            
            // Pipeline stage 2: CSA accumulation
            if (stage_valid) begin
                sum <= next_sum;
                carry <= next_carry;
            end
            
            // Counter and completion logic
            counter <= counter + 1;
            stage_valid <= 1'b1;
            
            if (counter == 2'b11) begin
                // Final addition when done
                p <= sum + carry;
                rdy <= 1'b1;
            end
        end
    end

endmodule