module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter INPUT_CLOCK_CYCLES = 7;  // Number of input clock cycles
parameter DIVIDED_CLOCK_CYCLES = 2;  // Number of divided clock cycles
parameter PHASE_LOCK_CYCLES = 1;  // Number of cycles to phase-lock

// Internal signals
reg [2:0] input_cnt;  // Input clock counter
reg [1:0] divided_cnt;  // Divided clock counter
reg phase_lock;  // Phase-locking signal
reg prev_clk_div;  // Previous divided clock signal

// Input clock counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        input_cnt <= 3'b000;  // Reset input clock counter
    end else begin
        input_cnt <= input_cnt + 1'b1;  // Increment input clock counter
        if (input_cnt == INPUT_CLOCK_CYCLES - 1) begin
            input_cnt <= 3'b000;  // Reset input clock counter
        end
    end
end

// Divided clock counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        divided_cnt <= 2'b00;  // Reset divided clock counter
    end else begin
        if (input_cnt == INPUT_CLOCK_CYCLES - 1) begin
            divided_cnt <= divided_cnt + 1'b1;  // Increment divided clock counter
        end
        if (divided_cnt == DIVIDED_CLOCK_CYCLES - 1) begin
            divided_cnt <= 2'b00;  // Reset divided clock counter
        end
    end
end

// Phase-locking state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_lock <= 1'b0;  // Reset phase-locking signal
    end else begin
        if (input_cnt == INPUT_CLOCK_CYCLES - 1 && divided_cnt == DIVIDED_CLOCK_CYCLES - 1) begin
            phase_lock <= 1'b1;  // Set phase-locking signal
        end else if (input_cnt == 0 && divided_cnt == 0) begin
            phase_lock <= 1'b0;  // Reset phase-locking signal
        end
    end
end

// Clock generator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;  // Reset divided clock signal
        prev_clk_div <= 1'b0;  // Reset previous divided clock signal
    end else begin
        if (phase_lock && !prev_clk_div) begin
            clk_div <= 1'b1;  // Set divided clock signal
        end else if (!phase_lock && prev_clk_div) begin
            clk_div <= 1'b0;  // Reset divided clock signal
        end
        prev_clk_div <= clk_div;  // Update previous divided clock signal
    end
end

endmodule