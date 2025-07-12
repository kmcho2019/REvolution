module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [4:0] ctr;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] product;

    // Booth encoding wires
    wire [2:0] booth_bits = multiplier[ctr*2 +: 3];
    wire [15:0] m2 = {multiplicand[14:0], 1'b0};
    wire [15:0] booth_result;

    // Booth encoder using continuous assignment
    assign booth_result = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? m2 :
        (booth_bits == 3'b100) ? (~m2 + 1'b1) :
        (~multiplicand + 1'b1); // default case for 101,110

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ctr <= 5'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 16'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    ctr <= 5'b0;
                    product <= 16'b0;
                    rdy <= 1'b0;
                end

                CALC: begin
                    if (ctr < 8) begin
                        // Accumulate the Booth result with proper shifting
                        product <= product + (booth_result << (ctr*2));
                        ctr <= ctr + 1;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    p <= product;
                    rdy <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule