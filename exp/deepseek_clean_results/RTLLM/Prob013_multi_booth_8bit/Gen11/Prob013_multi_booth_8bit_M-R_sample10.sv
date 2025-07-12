module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    // Internal registers
    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [1:0] state;
    reg [1:0] calc_counter;

    // Next state and calculation logic
    wire [15:0] next_p;
    wire [15:0] shifted_multiplicand = multiplicand << 2;
    wire [7:0] shifted_multiplier = multiplier >> 2;
    wire [1:0] next_counter = calc_counter + 1;
    wire done = (calc_counter == 2'b11);

    // Booth encoding arithmetic
    assign next_p = 
        (state == CALC) ? 
            case ({multiplier[1:0], prev_lsb})
                3'b000, 3'b111: p;
                3'b001, 3'b010: p + multiplicand;
                3'b011:         p + (multiplicand << 1);
                3'b100:         p - (multiplicand << 1);
                3'b101, 3'b110: p - multiplicand;
            endcase
        : 16'b0;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            calc_counter <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    p <= 16'b0;
                end
                CALC: begin
                    p <= next_p;
                    multiplicand <= shifted_multiplicand;
                    multiplier <= shifted_multiplier;
                    prev_lsb <= multiplier[1];
                    calc_counter <= next_counter;
                    state <= done ? DONE : CALC;
                end
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign rdy = (state == DONE);

endmodule