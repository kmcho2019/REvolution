module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Define the states
localparam IDLE = 2'b00;
localparam RUN = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

reg [15:0] multiplicand;
reg [15:0] next_multiplicand;

reg [15:0] multiplier;
reg [15:0] next_multiplier;

reg [4:0] ctr;
reg [4:0] next_ctr;

reg [15:0] product;
reg [15:0] next_product;

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        state <= next_state;
        multiplicand <= next_multiplicand;
        multiplier <= next_multiplier;
        product <= next_product;
        ctr <= next_ctr;
    end
end

// Combinational logic
always @(*) begin
    next_state = state;
    next_multiplicand = multiplicand;
    next_multiplier = multiplier;
    next_product = product;
    next_ctr = ctr;
    
    case (state)
        IDLE: begin
            next_multiplicand = {{8{b[7]}}, b};
            next_multiplier = {{8{a[7]}}, a};
            next_state = RUN;
        end
        RUN: begin
            if (ctr < 16) begin
                next_multiplicand = multiplicand << 1;
                if (multiplier[ctr] == 1) begin
                    next_product = product + multiplicand;
                end
                next_ctr = ctr + 1;
            end else begin
                next_state = DONE;
            end
        end
        DONE: begin
            p = product;
            rdy = 1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule