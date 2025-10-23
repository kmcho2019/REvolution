module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] state;  // State machine state
reg [2:0] counter;  // Counter for fractional frequency division

// State machine states
enum logic [2:0] {
    IDLE = 3'b000,
    CLK4 = 3'b001,
    CLK3 = 3'b010,
    RESET = 3'b011,
    DELAY = 3'b100,
    ADVANCE = 3'b101
} state_next;

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        counter <= 3'b000;
        clk_div <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (counter == MUL2_DIV_CLK - 1) begin
                    state <= RESET;
                end else if (counter < 4) begin
                    state <= CLK4;
                end else begin
                    state <= CLK3;
                end
                counter <= counter + 1'b1;
            end
            CLK4: begin
                state <= IDLE;
                clk_div <= ~clk_div;  // Toggle divided clock
            end
            CLK3: begin
                state <= IDLE;
            end
            RESET: begin
                state <= IDLE;
                counter <= 3'b000;
            end
            DELAY: begin
                state <= IDLE;
                clk_div <= ~clk_div;  // Delayed clock
            end
            ADVANCE: begin
                state <= IDLE;
                clk_div <= ~clk_div;  // Advanced clock
            end
        endcase
    end
end

// Combinational logic for phase-shifting and final fractional divided clock output
assign clk_div = (state == CLK4 || state == DELAY || state == ADVANCE) ? ~clk_div : 1'b0;

endmodule