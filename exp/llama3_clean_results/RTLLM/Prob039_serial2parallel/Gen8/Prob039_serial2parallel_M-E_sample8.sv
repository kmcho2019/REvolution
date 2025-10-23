module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// FSM states
enum logic [1:0] {IDLE, COLLECT} state;

// Counter to keep track of the number of bits collected
reg [2:0] cnt;

// Register to store the collected data
reg [7:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM and registers
        state <= IDLE;
        cnt <= 3'b000;
        data_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Wait for din_valid to be asserted
                if (din_valid) begin
                    // Transition to COLLECT state
                    state <= COLLECT;
                    // Reset the counter and data register
                    cnt <= 3'b000;
                    data_reg <= 8'b00000000;
                end
            end
            COLLECT: begin
                // Collect the serial data bits
                data_reg <= {data_reg[6:0], din_serial};
                // Increment the counter
                cnt <= cnt + 1'b1;
                // Check if 8 bits have been collected
                if (cnt == 3'b111) begin
                    // Transition back to IDLE state
                    state <= IDLE;
                    // Output the collected data
                    dout_parallel <= data_reg;
                    dout_valid <= 1'b1;
                end else begin
                    // Continue collecting data
                    dout_valid <= 1'b0;
                end
            end
        endcase
    end
end

endmodule