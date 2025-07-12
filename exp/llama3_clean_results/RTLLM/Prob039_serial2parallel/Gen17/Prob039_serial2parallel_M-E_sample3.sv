module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [1:0] state; // FSM states: 2'b00 - idle, 2'b01 - data reception
reg [2:0] bit_cnt; // Counter for the number of bits received
reg [7:0] data_reg; // Register to hold the received parallel data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM and registers
        state <= 2'b00;
        bit_cnt <= 3'b000;
        data_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (din_valid) begin
                    // Transition to data reception state upon receiving valid input
                    state <= 2'b01;
                    bit_cnt <= 3'b001; // Start with the first bit
                    data_reg <= {7'b0000000, din_serial}; // Shift in the first bit
                    dout_valid <= 1'b0; // Reset output valid signal
                end else begin
                    // Stay in idle state if no valid input
                    state <= 2'b00;
                end
            end
            2'b01: begin // Data reception state
                if (bit_cnt < 3'b1000) begin
                    // Continue shifting in bits until 8 bits are received
                    data_reg <= {data_reg[6:0], din_serial};
                    bit_cnt <= bit_cnt + 1'b1;
                    if (din_valid) begin
                        // Stay in data reception state
                        state <= 2'b01;
                    end else begin
                        // Transition back to idle state if no valid input
                        state <= 2'b00;
                    end
                end else begin
                    // Transition back to idle state after receiving 8 bits
                    state <= 2'b00;
                    dout_parallel <= data_reg; // Output the received byte
                    dout_valid <= 1'b1; // Set output valid signal
                end
            end
            default: begin
                // Default state - should not occur
                state <= 2'b00;
            end
        endcase
    end
end

endmodule