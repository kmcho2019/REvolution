module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Counter to cycle through 7 clock cycles
reg [2:0] counter;
reg [2:0] next_counter;

// Finite state machine states
reg [1:0] state;
reg [1:0] next_state;

// Signals for uneven clock periods
reg clk_div_4;
reg clk_div_3;
reg prev_clk;

// Phase-shifted clocks
reg clk_div_phase_shifted_4;
reg clk_div_phase_shifted_3;

always @(*) begin
    // Counter logic
    next_counter = counter + 1;
    if (next_counter == 7) begin
        next_counter = 0;
    end
    
    // Finite state machine logic
    case (state)
        2'b00: begin // Initial state
            if (counter == 3) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // State for 4 clock cycles
            if (counter == 6) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // State for 3 clock cycles
            if (counter == 0) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b10;
            end
        end
    endcase

    // Uneven clock periods logic
    if (state == 2'b00 || state == 2'b01) begin
        clk_div_4 = (counter == 3);
    end else begin
        clk_div_4 = 0;
    end

    if (state == 2'b10) begin
        clk_div_3 = (counter == 0);
    end else begin
        clk_div_3 = 0;
    end

    // Phase-shifted clocks logic
    if (prev_clk == 1 && clk == 0) begin // Falling edge
        clk_div_phase_shifted_4 = clk_div_4;
        clk_div_phase_shifted_3 = clk_div_3;
    end else if (prev_clk == 0 && clk == 1) begin // Rising edge
        clk_div_phase_shifted_4 = 0;
        clk_div_phase_shifted_3 = 0;
    end else begin
        clk_div_phase_shifted_4 = clk_div_phase_shifted_4;
        clk_div_phase_shifted_3 = clk_div_phase_shifted_3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        state <= 2'b00;
        prev_clk <= 0;
        clk_div <= 0;
        clk_div_4 <= 0;
        clk_div_3 <= 0;
        clk_div_phase_shifted_4 <= 0;
        clk_div_phase_shifted_3 <= 0;
    end else begin
        counter <= next_counter;
        state <= next_state;
        prev_clk <= clk;
        clk_div <= (clk_div_phase_shifted_4 | clk_div_phase_shifted_3);
    end
end

endmodule