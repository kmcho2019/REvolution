module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;
    
    reg state;
    reg [2:0] count;      // Iteration counter (0-3 for 4 steps)
    reg [15:0] multiplicand; // Extended to 16 bits for proper shifting
    reg [9:0] multiplier;    // Multiplier with 2 extra bits (Q)
    reg q_prev;              // Previous LSB for Booth encoding
    reg [7:0] a_reg, b_reg; // Input registers
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            state <= IDLE;
            p <= 16'b0;
            rdy <= 1'b1;    // Ready in idle state
            count <= 3'b0;
            multiplicand <= 16'b0;
            multiplier <= 10'b0;
            q_prev <= 1'b0;
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (a != a_reg || b != b_reg) begin
                        // Start new multiplication when inputs change
                        state <= BUSY;
                        p <= 16'b0;
                        rdy <= 1'b0;
                        count <= 3'b0;
                        multiplicand <= {{8{a[7]}}, a}; // Sign extend
                        multiplier <= {b, 2'b0};       // Initialize with 2 LSBs as 0
                        q_prev <= 1'b0;
                        a_reg <= a;
                        b_reg <= b;
                    end
                end
                
                BUSY: begin
                    if (count < 4) begin
                        // Booth Radix-4 encoding and operation
                        case (multiplier[2:0])
                            3'b000, 3'b111: ; // No operation
                            3'b001, 3'b010: p <= p + multiplicand;
                            3'b101, 3'b110: p <= p - multiplicand;
                            3'b011: p <= p + (multiplicand << 1);
                            3'b100: p <= p - (multiplicand << 1);
                        endcase
                        
                        // Arithmetic right shift by 2 bits
                        multiplier <= { {2{multiplier[9]}}, multiplier[9:2] };
                        count <= count + 1;
                    end else begin
                        // Multiplication complete
                        state <= IDLE;
                        rdy <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule