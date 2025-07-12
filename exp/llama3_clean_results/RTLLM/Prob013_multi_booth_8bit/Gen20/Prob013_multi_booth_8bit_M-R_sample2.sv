module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

parameter IDLE = 2'b00;
parameter INIT = 2'b01;
parameter MULTIPLY = 2'b10;
parameter DONE = 2'b11;

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        ctr <= 0;
        state <= IDLE;
        rdy <= 0;
        p <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= INIT;
            end
            INIT: begin
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= MULTIPLY;
                ctr <= 0;
            end
            MULTIPLY: begin
                if (ctr < 16) begin
                    multiplicand <= multiplicand << 1;
                    if (multiplier[ctr] == 1) begin
                        p <= p + multiplicand;
                    end
                    ctr <= ctr + 1;
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                rdy <= 1;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule