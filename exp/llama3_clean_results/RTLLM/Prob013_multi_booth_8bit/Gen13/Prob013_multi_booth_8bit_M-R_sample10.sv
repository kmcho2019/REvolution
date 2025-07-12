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
enum {IDLE, RESET, MULT, READY} state;

always @(posedge clk) begin
    case(state)
        IDLE: begin
            if (reset) state <= RESET;
        end
        RESET: begin
            multiplicand <= { {8{b[7]}}, b };
            multiplier <= { {8{a[7]}}, a };
            p <= 0;
            ctr <= 0;
            state <= MULT;
        end
        MULT: begin
            if (ctr < 16) begin
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end else begin
                state <= READY;
            end
        end
        READY: begin
            rdy <= 1;
            if (~reset) state <= IDLE;
        end
    endcase
end

endmodule