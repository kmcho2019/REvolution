module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [1:0] state; // State machine with two main states: IDLE and SHIFT
reg [2:0] cnt; // 3-bit counter to keep track of the shift operations
reg clk_en; // Clock enable signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine, counter, and output register
        state <= 2'b00; // IDLE state
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (din_valid) begin
                    // Transition to SHIFT state and set clock enable
                    state <= 2'b01;
                    clk_en <= 1'b1;
                end else begin
                    // Stay in IDLE state and disable clock
                    state <= 2'b00;
                    clk_en <= 1'b0;
                end
            end
            2'b01: begin // SHIFT state
                if (cnt == 3'b111) begin
                    // Transition back to IDLE state, set output valid, and disable clock
                    state <= 2'b00;
                    dout_valid <= 1'b1;
                    clk_en <= 1'b0;
                end else begin
                    // Stay in SHIFT state, shift in serial data, and increment counter
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                    cnt <= cnt + 1'b1;
                end
            end
            default: begin
                // Default case: stay in IDLE state and disable clock
                state <= 2'b00;
                clk_en <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (clk_en) begin
        // Update output register based on clock enable
        dout_parallel <= {dout_parallel[6:0], din_serial};
    end
end

endmodule