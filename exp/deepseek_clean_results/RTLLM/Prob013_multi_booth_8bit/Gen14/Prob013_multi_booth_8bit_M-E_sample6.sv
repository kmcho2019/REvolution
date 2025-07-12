module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State machine definitions
    typedef enum {PREPARE, SELECT, ACCUMULATE} state_t;
    state_t current_state;

    // Precomputed partial products
    reg [15:0] pp_0, pp_1, pp_2, pp_m1, pp_m2;
    
    // Working registers
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extra bit for sign extension
    reg [1:0] counter;
    reg [1:0] booth_bits;
    reg prev_bit;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Extra bit for booth encoding
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            current_state <= PREPARE;
            prev_bit <= 1'b0;
            
            // Precompute all possible partial products
            pp_0 <= 16'b0;
            pp_1 <= {{8{a[7]}}, a};
            pp_2 <= {{8{a[7]}}, a} << 1;
            pp_m1 <= -{{8{a[7]}}, a};
            pp_m2 <= -({{8{a[7]}}, a} << 1);
        end else begin
            case (current_state)
                PREPARE: begin
                    // Extract current booth bits
                    booth_bits <= multiplier[1:0];
                    prev_bit <= multiplier[2];
                    current_state <= SELECT;
                end
                
                SELECT: begin
                    // Select appropriate partial product
                    case ({booth_bits, prev_bit})
                        3'b000, 3'b111: p <= p;
                        3'b001, 3'b010: p <= p + pp_1;
                        3'b011:         p <= p + pp_2;
                        3'b100:         p <= p + pp_m2;
                        3'b101, 3'b110: p <= p + pp_m1;
                    endcase
                    current_state <= ACCUMULATE;
                end
                
                ACCUMULATE: begin
                    // Shift multiplier and multiplicand
                    multiplier <= multiplier >> 2;
                    multiplicand <= multiplicand << 2;
                    
                    // Update precomputed products for new position
                    pp_1 <= ({{8{a[7]}}, a} << (counter * 2 + 2));
                    pp_2 <= ({{8{a[7]}}, a} << (counter * 2 + 3));
                    pp_m1 <= -({{8{a[7]}}, a} << (counter * 2 + 2));
                    pp_m2 <= -({{8{a[7]}}, a} << (counter * 2 + 3));
                    
                    // Check completion
                    if (counter == 2'b11) begin
                        rdy <= 1'b1;
                        current_state <= PREPARE;
                    end else begin
                        counter <= counter + 1;
                        current_state <= PREPARE;
                    end
                end
            endcase
        end
    end

endmodule