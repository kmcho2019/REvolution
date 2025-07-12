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

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg [1:0] state;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        p <= 0;
    end else begin
        case (state)
            IDLE: begin
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= RUN;
            end
            RUN: begin
                if (ctr < 16) begin
                    multiplicand <= multiplicand << 1;
                    if (multiplier[ctr]) begin
                        product <= product + multiplicand;
                    end
                    ctr <= ctr + 1;
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                p <= product;
                rdy <= 1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule