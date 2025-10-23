module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// Finite state machine states
enum logic [1:0] {IDLE, SHIFTING} state;

// 3-bit counter to keep track of the number of serial input data bits received
reg [2:0] cnt;

// Output register
reg [7:0] output_reg;

// Clock gating signal
reg clk_gate;

// Initialize the state machine and output valid signal
initial begin
    state = IDLE;
    dout_valid = 1'b0;
    output_reg = 8'b00000000;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine, counter, and output register
        state <= IDLE;
        cnt <= 3'b000;
        output_reg <= 8'b00000000;
        dout_valid <= 1'b0;
        clk_gate <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Wait for valid input data
                if (din_valid) begin
                    // Transition to SHIFTING state
                    state <= SHIFTING;
                    // Reset the counter
                    cnt <= 3'b000;
                    // Clear the output register
                    output_reg <= 8'b00000000;
                    // Enable the clock gate
                    clk_gate <= 1'b1;
                end else begin
                    // Disable the clock gate
                    clk_gate <= 1'b0;
                end
            end
            SHIFTING: begin
                // Shift in the serial input data
                output_reg <= {output_reg[6:0], din_serial};
                // Increment the counter
                cnt <= cnt + 1'b1;
                // Check if eight bits have been shifted in
                if (cnt == 3'b111) begin
                    // Transition back to IDLE state
                    state <= IDLE;
                    // Make the output valid
                    dout_valid <= 1'b1;
                    // Disable the clock gate
                    clk_gate <= 1'b0;
                end
            end
        endcase
    end
end

// Assign the output register to the output port
always @(*) begin
    if (clk_gate) begin
        dout_parallel <= output_reg;
    end else begin
        dout_parallel <= 8'b00000000;
    end
end

endmodule