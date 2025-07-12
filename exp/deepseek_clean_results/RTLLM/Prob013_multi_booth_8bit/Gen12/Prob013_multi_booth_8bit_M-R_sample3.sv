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
    reg [2:0] counter;
    reg [1:0] state;

    // Booth encoding signals
    wire [2:0] booth_enc [0:3];
    wire [15:0] pp [0:3];
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};
    wire [15:0] multiplicand_neg = ~multiplicand + 1;
    wire [15:0] multiplicand_x2_neg = ~multiplicand_x2 + 1;

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    // Booth encoding for each group
    assign booth_enc[0] = {multiplier[1:0], 1'b0};
    assign booth_enc[1] = multiplier[3:1];
    assign booth_enc[2] = multiplier[5:3];
    assign booth_enc[3] = multiplier[7:5];

    // Partial product generation
    assign pp[0] = (booth_enc[0] == 3'b001 || booth_enc[0] == 3'b010) ? multiplicand :
                  (booth_enc[0] == 3'b011) ? multiplicand_x2 :
                  (booth_enc[0] == 3'b100) ? multiplicand_x2_neg :
                  (booth_enc[0] == 3'b101 || booth_enc[0] == 3'b110) ? multiplicand_neg : 16'b0;

    assign pp[1] = (booth_enc[1] == 3'b001 || booth_enc[1] == 3'b010) ? multiplicand :
                  (booth_enc[1] == 3'b011) ? multiplicand_x2 :
                  (booth_enc[1] == 3'b100) ? multiplicand_x2_neg :
                  (booth_enc[1] == 3'b101 || booth_enc[1] == 3'b110) ? multiplicand_neg : 16'b0;

    assign pp[2] = (booth_enc[2] == 3'b001 || booth_enc[2] == 3'b010) ? multiplicand :
                  (booth_enc[2] == 3'b011) ? multiplicand_x2 :
                  (booth_enc[2] == 3'b100) ? multiplicand_x2_neg :
                  (booth_enc[2] == 3'b101 || booth_enc[2] == 3'b110) ? multiplicand_neg : 16'b0;

    assign pp[3] = (booth_enc[3] == 3'b001 || booth_enc[3] == 3'b010) ? multiplicand :
                  (booth_enc[3] == 3'b011) ? multiplicand_x2 :
                  (booth_enc[3] == 3'b100) ? multiplicand_x2_neg :
                  (booth_enc[3] == 3'b101 || booth_enc[3] == 3'b110) ? multiplicand_neg : 16'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 16'b0;
            counter <= 3'b0;
            state <= IDLE;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    counter <= 3'b0;
                end

                CALC: begin
                    // Accumulate partial products with proper shifting
                    product <= product + (pp[0] << (counter*2)) + 
                                      (pp[1] << (counter*2 + 2)) + 
                                      (pp[2] << (counter*2 + 4)) + 
                                      (pp[3] << (counter*2 + 6));

                    // Shift multiplier for next group
                    multiplier <= multiplier >> 2;

                    if (counter == 3'b011) begin
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