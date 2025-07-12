module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    parameter IDLE = 2'b00;
    parameter CALCULATE = 2'b01;
    parameter DONE = 2'b10;

    // Internal registers
    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [3:0] counter;
    reg [15:0] accumulator;

    // Booth encoding wires
    wire [2:0] booth_bits;
    wire [15:0] booth_result;
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};

    // Booth encoder
    assign booth_bits = (counter < 4) ? 
                        {multiplier[1:0], 1'b0} :
                        (counter < 8) ? 
                        {multiplier[3:2], multiplier[1]} :
                        (counter < 12) ? 
                        {multiplier[5:4], multiplier[3]} : 
                        {multiplier[7:6], multiplier[5]};

    assign booth_result = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? multiplicand_x2 :
        (booth_bits == 3'b100) ? (~multiplicand_x2 + 1'b1) :
        (~multiplicand + 1'b1);

    // Shift amount calculation
    wire [3:0] shift_amount = 
        (counter < 4) ? counter[1:0] * 2 :
        (counter < 8) ? (counter[1:0] + 2'd2) * 2 :
        (counter < 12) ? (counter[1:0] + 2'd4) * 2 :
        (counter[1:0] + 2'd6) * 2;

    // Shifted partial product
    wire [15:0] partial_product = booth_result << shift_amount;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'b0;
            accumulator <= 16'b0;
            counter <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Initialize registers
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    accumulator <= 16'b0;
                    counter <= 4'b0;
                    rdy <= 1'b0;
                    state <= CALCULATE;
                end

                CALCULATE: begin
                    if (counter < 16) begin
                        // Accumulate partial product
                        accumulator <= accumulator + partial_product;
                        counter <= counter + 1;
                    end else begin
                        // Calculation complete
                        p <= accumulator;
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold until next reset
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule