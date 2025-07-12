module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state, next_state;
    reg [1:0] counter;  // 4 cycles for 8-bit Radix-4
    
    // Data registers
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extended with sign bit
    reg [15:0] product;
    reg prev_bit;
    
    // Booth encoding
    wire [2:0] booth_bits = {multiplier[1:0], prev_bit};
    wire [15:0] partial_product;
    
    // Partial product selection (Radix-4)
    assign partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? {multiplicand[14:0], 1'b0} :  // 2*M
        (booth_bits == 3'b100) ? ~({multiplicand[14:0], 1'b0}) + 1'b1 :  // -2*M
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? ~multiplicand + 1'b1 :  // -M
        16'b0;

    // State transition
    always @(*) begin
        case (state)
            IDLE: next_state = reset ? IDLE : BUSY;
            BUSY: next_state = (counter == 2'b11) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            product <= 16'b0;
            multiplicand <= 16'b0;
            multiplier <= 9'b0;
            prev_bit <= 1'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    // Initialize registers
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {b[7], b};  // Sign extend
                    prev_bit <= 1'b0;
                    product <= 16'b0;
                    counter <= 2'b0;
                    rdy <= 1'b0;
                end
                
                BUSY: begin
                    // Accumulate partial product
                    product <= product + partial_product;
                    
                    // Arithmetic shift right by 2 bits
                    multiplier <= {multiplier[8], multiplier[8], multiplier[8:2]};
                    prev_bit <= multiplier[1];
                    
                    // Update counter and ready signal
                    counter <= counter + 1;
                    rdy <= (counter == 2'b10);  // Assert one cycle early
                    
                    // Output result when done
                    if (counter == 2'b11) begin
                        p <= product + partial_product;
                    end
                end
            endcase
        end
    end

endmodule