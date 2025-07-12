module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Define the states of the FSM
enum logic [1:0] {IDLE, MULT} state, next_state;

// Define the registers
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;

// Define the combinational logic
assign next_state = (reset) ? IDLE : (state == IDLE) ? MULT : (ctr < 16) ? MULT : IDLE;

// Define the sequential logic
always @(posedge clk) begin
    case (next_state)
        IDLE: begin
            multiplicand <= { {8{b[7]}}, b };
            multiplier <= { {8{a[7]}}, a };
            product <= 0;
            ctr <= 0;
            rdy <= 0;
            state <= MULT;
        end
        MULT: begin
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
            if (ctr >= 16) begin
                rdy <= 1;
                state <= IDLE;
            end else begin
                state <= MULT;
            end
        end
        default: state <= IDLE;
    endcase
end

// Assign the output
assign p = product;

endmodule