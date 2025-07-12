module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

typedef enum logic [1:0] {
    IDLE,
    INIT,
    MULTIPLY,
    DONE
} state_t;

state_t state, next_state;

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(a != 0 || b != 0) begin
                    state <= INIT;
                end
            end
            INIT: begin
                multiplicand <= { {8{b[7]}}, b };
                multiplier <= { {8{a[7]}}, a };
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                if(ctr < 16) begin
                    if(multiplier[ctr]) begin
                        product <= product + multiplicand;
                    end
                    multiplicand <= multiplicand << 1;
                    ctr <= ctr + 1;
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                p <= product;
                rdy <= 1;
            end
        endcase
    end
end

assign rdy = (state == DONE);

endmodule