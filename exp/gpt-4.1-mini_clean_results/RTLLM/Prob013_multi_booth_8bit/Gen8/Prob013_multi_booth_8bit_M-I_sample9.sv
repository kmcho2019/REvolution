module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,    // multiplicand
    input      [7:0]   b,    // multiplier
    output reg [15:0]  p,    // product output
    output reg         rdy    // ready signal
);

    // Declare signed registers for proper signed arithmetic
    reg signed [16:0] multiplicand;      // 17 bits for sign extension and shifts
    reg signed [17:0] multiplier_ext;    // 17 bits multiplier + appended zero bit for Booth encoding
    reg signed [33:0] product;            // double width accumulator (34 bits = 16*2 + 2 extra bits)
    reg [3:0]         cycle_ctr;

    // Booth encoded digit extraction wires
    wire [2:0] booth_bits;

    assign booth_bits = multiplier_ext[2:0];  // 3 LSBs for Booth encoding (q0 q-1 q-2)

    // Booth multiplier FSM states
    typedef enum reg [1:0] {IDLE=2'd0, RUN=2'd1, DONE=2'd2} state_t;
    reg [1:0] state;

    // Decode Booth bits to get multiplier factor: -2, -1, 0, +1, +2
    // Based on Booth radix-4 recoding table:
    // 000 or 111 => 0
    // 001 or 010 => +1
    // 011        => +2
    // 100        => -2
    // 101 or 110 => -1

    reg signed [16:0] add_sub_val;  // value to add or subtract shifted accordingly

    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: add_sub_val = 17'sd0;
            3'b001, 3'b010: add_sub_val = multiplicand;
            3'b011:         add_sub_val = multiplicand <<< 1;  // multiply by 2
            3'b100:         add_sub_val = - (multiplicand <<< 1); // multiply by -2
            3'b101, 3'b110: add_sub_val = - multiplicand; // multiply by -1
            default:        add_sub_val = 17'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= { {9{a[7]}}, a }; // sign-extend a from 8 to 17 bits
            multiplier_ext <= { b, 1'b0, 8'b0 }; // b in bits [16:9], extra zero appended at LSB (bit 0)
            multiplier_ext[16:9] <= b; // Place b in MSB 8 bits
            multiplier_ext[8:1]  <= 8'b0;
            multiplier_ext[0]    <= 1'b0;
            product     <= 34'sd0;
            cycle_ctr   <= 4'd0;
            p           <= 16'd0;
            rdy         <= 1'b0;
            state       <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    // Load registers again to start multiplication
                    multiplicand <= { {9{a[7]}}, a };
                    multiplier_ext <= { b, 1'b0 }; // concatenate multiplier and 0 bit for Booth encoding
                    product <= 34'sd0;
                    cycle_ctr <= 4'd0;
                    state <= RUN;
                end

                RUN: begin
                    // Add or subtract shifted multiplicand based on Booth encoding
                    product <= product + ( { {17{add_sub_val[16]}}, add_sub_val } <<< (2*cycle_ctr) );
                    // Shift multiplier right by 2 bits for next group
                    multiplier_ext <= { 2'b00, multiplier_ext[17:2] };
                    cycle_ctr <= cycle_ctr + 1;

                    if (cycle_ctr == 4'd7) begin
                        // On last cycle, output product
                        // Product is 34 bits signed accumulator, final product is bits [16:1]
                        // Radix-4 Booth product after processing 8 groups of 2 bits each covers 16 bits
                        // Extract bits [16:1] as 16-bit product
                        p <= product[16:1];
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Maintain ready signal high until reset
                    rdy <= 1'b1;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule