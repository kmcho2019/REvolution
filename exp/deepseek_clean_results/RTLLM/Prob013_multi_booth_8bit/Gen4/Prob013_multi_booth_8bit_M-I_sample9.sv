module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] product;
    reg [3:0] counter;
    
    // State machine
    typedef enum logic [1:0] {
        IDLE,
        PROCESS,
        DONE
    } state_t;
    
    state_t state;
    
    // Booth encoding
    wire [2:0] booth_bits = multiplier[1:0];
    wire [15:0] pp;
    
    // Partial product selection
    assign pp = (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
                (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
                (booth_bits == 3'b011) ? (multiplicand << 1) :
                (booth_bits == 3'b100) ? -(multiplicand << 1) : -multiplicand;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 0;
            counter <= 0;
            rdy <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication
                    product <= 0;
                    counter <= 0;
                    rdy <= 0;
                    state <= PROCESS;
                end
                
                PROCESS: begin
                    if (counter < 4) begin
                        // Accumulate partial product
                        product <= product + (pp << (counter * 2));
                        
                        // Shift multiplier for next group
                        multiplier <= multiplier >> 2;
                        counter <= counter + 1;
                    end else begin
                        // Multiplication complete
                        p <= product;
                        rdy <= 1;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    // Hold until next reset
                    rdy <= 1;
                end
            endcase
        end
    end

endmodule