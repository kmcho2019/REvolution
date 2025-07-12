module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg [1:0] state;

// Define the states
localparam IDLE = 2'b00;
localparam RUN = 2'b01;
localparam DONE = 2'b10;

// Next state logic
assign next_state = (state == IDLE && ~reset) ? RUN :
                   (state == RUN && ctr < 16) ? RUN :
                   (state == RUN && ctr >= 16) ? DONE :
                   (state == DONE) ? IDLE :
                   IDLE;

// Output logic
assign p = (state == DONE) ? product : 0;
assign rdy = (state == DONE) ? 1 : 0;

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
    end else begin
        case (state)
            IDLE: begin
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= next_state;
            end
            RUN: begin
                multiplicand <= multiplicand << 1;
                if (multiplier[ctr] == 1) begin
                    product <= product + multiplicand;
                end
                ctr <= ctr + 1;
                state <= next_state;
            end
            DONE: begin
                state <= next_state;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule