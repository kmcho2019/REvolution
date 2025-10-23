module signal_generator(
    input  clk,
    input  rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state_reg;
reg [4:0] next_wave;
reg [0:0] next_state;

// Initialize wave and state registers
initial begin
    wave_reg = 0;
    state_reg = 0;
end

// Always block for sequential logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, clear wave and state registers
        wave_reg <= 0;
        state_reg <= 0;
    end else begin
        // Update wave and state registers
        wave_reg <= next_wave;
        state_reg <= next_state;
    end
end

// Combinational logic for next state and wave calculation
always @ (*) begin
    case (state_reg)
        0: begin
            // If state is 0, increment wave by 1
            next_wave = wave_reg + 1;
            if (wave_reg == 31) begin
                // Transition to state 1 when wave reaches 31
                next_state = 1;
            end else begin
                next_state = 0;
            end
        end
        1: begin
            // If state is 1, decrement wave by 1
            next_wave = wave_reg - 1;
            if (wave_reg == 0) begin
                // Transition to state 0 when wave reaches 0
                next_state = 0;
            end else begin
                next_state = 1;
            end
        end
        default: begin
            next_wave = 0;
            next_state = 0;
        end
    endcase
end

// Continuous assignment for output
assign wave = wave_reg;

endmodule