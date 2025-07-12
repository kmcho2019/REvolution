module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg prev_clk;   // Previous clock value for edge detection
reg clk_div_int1;  // Intermediate divided clock signal 1 (4 cycles)
reg clk_div_int2;  // Intermediate divided clock signal 2 (3 cycles)

// State machine states
enum logic [1:0] {IDLE, STATE1, STATE2} state, next_state;

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 3'b000;
        prev_clk <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        state <= next_state;
        prev_clk <= clk;
        case (state)
            IDLE: begin
                if (cnt < 4) begin
                    cnt <= cnt + 1'b1;
                end else begin
                    cnt <= 3'b000;
                end
            end
            STATE1: begin
                if (cnt < 4) begin
                    cnt <= cnt + 1'b1;
                end else begin
                    cnt <= 3'b000;
                end
            end
            STATE2: begin
                if (cnt < 3) begin
                    cnt <= cnt + 1'b1;
                end else begin
                    cnt <= 3'b000;
                end
            end
        endcase
    end
end

// Combinational logic for next state and divided clock signals
always @(*) begin
    case (state)
        IDLE: begin
            if (cnt == 3'b100) begin
                next_state = STATE1;
            end else begin
                next_state = IDLE;
            end
            clk_div_int1 = (cnt == 3'b100)? 1'b1 : 1'b0;
            clk_div_int2 = 1'b0;
        end
        STATE1: begin
            if (cnt == 3'b100) begin
                next_state = STATE2;
            end else begin
                next_state = STATE1;
            end
            clk_div_int1 = 1'b1;
            clk_div_int2 = 1'b0;
        end
        STATE2: begin
            if (cnt == 3'b011) begin
                next_state = IDLE;
            end else begin
                next_state = STATE2;
            end
            clk_div_int1 = 1'b0;
            clk_div_int2 = 1'b1;
        end
    endcase
end

// Phase-shifting logic
assign clk_div = (state == STATE1 &&!prev_clk && clk) || (state == STATE2 &&!prev_clk && clk);

endmodule