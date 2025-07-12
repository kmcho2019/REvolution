module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg [1:0] state;  // Using a 2-bit state register with one-hot encoding

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b01;  // Initialize state to incrementing (one-hot encoding)
        wave_reg <= 5'b00000;
    end else begin
        case (state)
            2'b01: begin  // Incrementing state
                if (wave_reg == 5'b11111) begin  // Check if wave_reg has reached 31
                    state <= 2'b10;  // Transition to decrementing state
                end else begin
                    wave_reg <= wave_reg + 1'b1;  // Increment wave_reg by 1
                end
            end
            2'b10: begin  // Decrementing state
                if (wave_reg == 5'b00000) begin  // Check if wave_reg has reached 0
                    state <= 2'b01;  // Transition back to incrementing state
                end else begin
                    wave_reg <= wave_reg - 1'b1;  // Decrement wave_reg by 1
                end
            end
            default: begin
                state <= 2'b01;  // Default to incrementing state
                wave_reg <= 5'b00000;
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule