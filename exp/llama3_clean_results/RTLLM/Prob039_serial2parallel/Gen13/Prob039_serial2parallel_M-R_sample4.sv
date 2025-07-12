module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [1:0] state; // 2-state state machine: IDLE (0), CONVERTING (1)
reg [3:0] cnt; // Counter for bits received
reg [7:0] dout_parallel_reg; // Register for parallel output data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE state
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (din_valid) begin
                    state <= 2'b01; // Move to CONVERTING state
                    cnt <= 4'b0001; // Initialize counter
                    dout_parallel_reg <= {7'b0000000, din_serial}; // Shift in first bit
                    dout_valid <= 1'b0;
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                    cnt <= 4'b0000;
                    dout_parallel_reg <= 8'b00000000;
                    dout_valid <= 1'b0;
                end
            end
            2'b01: begin // CONVERTING state
                if (cnt < 4'b1000) begin
                    cnt <= cnt + 1'b1; // Increment counter
                    dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial}; // Shift in next bit
                    state <= 2'b01; // Stay in CONVERTING state
                    dout_valid <= 1'b0;
                end else begin
                    state <= 2'b00; // Return to IDLE state
                    cnt <= 4'b0000; // Reset counter
                    dout_valid <= 1'b1; // Output valid
                end
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
                cnt <= 4'b0000;
                dout_parallel_reg <= 8'b00000000;
                dout_valid <= 1'b0;
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;

endmodule