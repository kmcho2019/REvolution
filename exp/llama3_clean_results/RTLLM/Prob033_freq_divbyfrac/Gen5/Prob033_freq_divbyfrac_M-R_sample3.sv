module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Enum for state machine
enum logic [2:0] {IDLE, DIV_4, DIV_3} state, next_state;

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg prev_clk;  // Previous clock value for edge detection
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 3'b000;
        prev_clk <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == IDLE) begin
            cnt <= 3'b000;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        prev_clk <= clk;
    end
end

// Combinational logic for state transitions
always @(*) begin
    case (state)
        IDLE: begin
            if (cnt < 4) begin
                next_state = DIV_4;
            end else begin
                next_state = DIV_3;
            end
        end
        DIV_4: begin
            if (cnt >= 4) begin
                next_state = DIV_3;
            end else begin
                next_state = DIV_4;
            end
        end
        DIV_3: begin
            if (cnt == MUL2_DIV_CLK - 1) begin
                next_state = IDLE;
            end else begin
                next_state = DIV_3;
            end
        end
    endcase
end

// Combinational logic for intermediate clocks
assign clk_div_int1 = (state == DIV_4) ? 1'b1 : 1'b0;
assign clk_div_int2 = (state == DIV_3) ? 1'b1 : 1'b0;

// Combinational logic for final fractional divided clock output
assign clk_div = (clk && !prev_clk && (state == DIV_4)) || (!clk && prev_clk && (state == DIV_3));

endmodule