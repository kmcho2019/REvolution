module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// States for the FSM
enum logic [1:0] {IDLE, MULTIPLY, DONE} state, next_state;

// Registers
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;

// FSM Logic
always_comb begin
    case(state)
        IDLE: begin
            if(reset) next_state = IDLE;
            else next_state = MULTIPLY;
        end
        MULTIPLY: begin
            if(ctr < 16) next_state = MULTIPLY;
            else next_state = DONE;
        end
        DONE: begin
            next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential Logic
always_ff @(posedge clk) begin
    case(next_state)
        IDLE: begin
            multiplicand <= { {8{b[7]}}, b };
            multiplier <= { {8{a[7]}}, a };
            product <= 0;
            ctr <= 0;
            rdy <= 0;
        end
        MULTIPLY: begin
            multiplicand <= multiplicand << 1;
            if(multiplier[ctr] == 1) product <= product + multiplicand;
            ctr <= ctr + 1;
        end
        DONE: begin
            rdy <= 1;
        end
        default: ;
    endcase
    state <= next_state;
    p <= product;
end

endmodule