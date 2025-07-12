module signal_generator (
    input  wire clk,        // Clock signal
    input  wire rst_n,      // Active-low reset signal
    output reg  [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave_reg;         // Register to store the waveform signal
reg state_reg;              // Register to store the current state
reg [4:0] next_wave;        // Next value of the waveform signal
reg next_state;             // Next state of the FSM

// Initialize the waveform signal and state registers
initial begin
    wave_reg = 5'd0;
    state_reg = 1'b0;
end

// Update the waveform signal and state registers on the positive edge of the clock signal or the negative edge of the reset signal
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin       // Reset condition
        wave_reg <= 5'd0;
        state_reg <= 1'b0;
    end else begin
        wave_reg <= next_wave;
        state_reg <= next_state;
    end
end

// Combinational logic to calculate the next state and waveform signal
always @(*) begin
    case (state_reg)
        1'b0: begin         // State 0: Increment the waveform signal
            next_wave = wave_reg + 1;
            if (wave_reg == 5'd31) begin
                next_state = 1'b1;
            end else begin
                next_state = 1'b0;
            end
        end
        1'b1: begin         // State 1: Decrement the waveform signal
            next_wave = wave_reg - 1;
            if (wave_reg == 5'd0) begin
                next_state = 1'b0;
            end else begin
                next_state = 1'b1;
            end
        end
        default: begin
            next_wave = wave_reg;
            next_state = state_reg;
        end
    endcase
end

// Continuous assignment to output the waveform signal
assign wave = wave_reg;

endmodule