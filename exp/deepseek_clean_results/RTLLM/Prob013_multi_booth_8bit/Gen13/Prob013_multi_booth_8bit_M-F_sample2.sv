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
    reg [4:0] counter;
    reg [1:0] state;

    // Booth encoding signals
    wire [2:0] booth_enc;
    wire [15:0] pp;
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};
    wire [15:0] multiplicand_neg = ~multiplicand + 1;
    wire [15:0] multiplicand_x2_neg = ~multiplicand_x2 + 1;

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    // Current Booth encoding (overlapping 3-bit groups)
    assign booth_enc = (counter < 4) ? 
                      {multiplier[counter*2+1], multiplier[counter*2:counter*2-1]} : 3'b0;

    // Partial product generation
    assign pp = (booth_enc == 3'b001 || booth_enc == 3'b010) ? multiplicand :
               (booth_enc == 3'b011) ? multiplicand_x2 :
               (booth_enc == 3'b100) ? multiplicand_x2_neg :
               (booth_enc == 3'b101 || booth_enc == 3'b110) ? multiplicand_neg : 16'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with proper sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 16'b0;
            counter <= 5'b0;
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    counter <= 5'b0;
                    product <= 16'b0;
                    rdy <= 1'b0;
                end

                CALC: begin
                    // Accumulate partial product with proper shifting
                    product <= product + (pp << (counter*2));
                    
                    // Increment counter
                    if (counter == 4) begin
                        state <= DONE;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                DONE: begin
                    p <= product;
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule