module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] mcand;        // Sign-extended multiplicand
    reg [15:0] mcand_x2;     // Pre-computed x2 value (registered)
    reg [2:0] mplier_bits;   // Current multiplier bits (2 bits + prev)
    reg [1:0] counter;       // 2-bit counter (0-3)
    reg [7:0] b_reg;         // Registered multiplier
    
    // Control signals
    wire [1:0] next_counter;
    wire [2:0] next_mplier_bits;
    wire [15:0] next_mcand;
    wire [15:0] next_mcand_x2;
    wire [15:0] booth_result;
    wire zero_operand;
    wire computation_done;
    
    // Early zero detection
    assign zero_operand = (a == 8'b0) | (b == 8'b0);
    assign computation_done = (counter == 2'b11) | zero_operand;
    
    // Pre-compute next values
    assign next_counter = reset ? 2'b0 : (rdy ? counter : counter + 1);
    assign next_mcand = reset ? {{8{a[7]}}, a} : (mcand << 2);
    assign next_mcand_x2 = next_mcand << 1;
    
    // Booth encoding selection
    always @(*) begin
        case (mplier_bits)
            3'b001, 3'b010: booth_result = p + mcand;      // +1
            3'b011:         booth_result = p + mcand_x2;   // +2
            3'b100:         booth_result = p - mcand_x2;   // -2
            3'b101, 3'b110: booth_result = p - mcand;      // -1
            default:        booth_result = p;              // +0 (000,111)
        endcase
    end
    
    // Multiplier bit selection (pre-computed)
    assign next_mplier_bits = reset ? {b[1:0], 1'b0} : 
                            {b_reg[counter*2+3], b_reg[counter*2+2], b_reg[counter*2+1]};
    
    // Main sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Initialize all registers
            mcand <= {{8{a[7]}}, a};
            mcand_x2 <= ({{8{a[7]}}, a} << 1);
            b_reg <= b;
            mplier_bits <= {b[1:0], 1'b0};
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= zero_operand;
        end
        else if (!rdy) begin
            // Pipeline stage 1: Update operands
            mcand <= next_mcand;
            mcand_x2 <= next_mcand_x2;
            mplier_bits <= next_mplier_bits;
            
            // Pipeline stage 2: Update product
            p <= booth_result;
            counter <= next_counter;
            
            // Completion detection
            if (computation_done) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule