module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] state; // 8 bits to represent 8 states using one-hot encoding
reg disc_reg, flag_reg, err_reg;

// Define the states using one-hot encoding
localparam IDLE = 8'b00000001;
localparam ONE = 8'b00000010;
localparam TWO = 8'b00000100;
localparam THREE = 8'b00001000;
localparam FOUR = 8'b00010000;
localparam FIVE = 8'b00100000;
localparam SIX = 8'b01000000;
localparam SEVEN = 8'b10000000;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (1'b1)
            state[0]: begin // IDLE
                if (in) state <= ONE;
                else state <= IDLE;
            end
            state[1]: begin // ONE
                if (in) state <= TWO;
                else state <= IDLE;
            end
            state[2]: begin // TWO
                if (in) state <= THREE;
                else state <= IDLE;
            end
            state[3]: begin // THREE
                if (in) state <= FOUR;
                else state <= IDLE;
            end
            state[4]: begin // FOUR
                if (in) state <= FIVE;
                else state <= IDLE;
            end
            state[5]: begin // FIVE
                if (in) state <= SIX;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            end
            state[6]: begin // SIX
                if (in) begin
                    state <= SEVEN;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            end
            state[7]: begin // SEVEN
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN;
                    err_reg <= 1;
                end
            end
        endcase
    end
end

// Output logic optimization
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// Apply clock gating to reduce power consumption
reg clk_gated;
always @(posedge clk) begin
    if (reset) clk_gated <= 0;
    else if (state == IDLE) clk_gated <= 0;
    else clk_gated <= 1;
end

// Use clk_gated instead of clk in the design
// (Note: This requires additional changes to the design, which are not shown here)

endmodule