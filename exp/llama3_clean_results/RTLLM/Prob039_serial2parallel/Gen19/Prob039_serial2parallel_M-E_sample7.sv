module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// Define the states of the finite state machine
enum logic [1:0] {
    IDLE,
    RECEIVE,
    OUTPUT
} state, next_state;

// Counter to keep track of the number of bits received
reg [2:0] cnt;

// Clock enable signal for clock gating
reg clk_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state, counter, output, and validity signal
        state <= IDLE;
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
        clk_enable <= 1'b0;
    end else begin
        // Update the state
        state <= next_state;
        
        case (state)
            IDLE: begin
                // Wait for valid input data
                if (din_valid) begin
                    next_state <= RECEIVE;
                    cnt <= 3'b001;
                    dout_parallel[7] <= din_serial;
                    dout_valid <= 1'b0;
                    clk_enable <= 1'b1;
                end else begin
                    next_state <= IDLE;
                    clk_enable <= 1'b0;
                end
            end
            RECEIVE: begin
                // Accumulate the serial input data
                if (cnt < 3'b100) begin
                    next_state <= RECEIVE;
                    cnt <= cnt + 1'b1;
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                    dout_valid <= 1'b0;
                end else begin
                    next_state <= OUTPUT;
                    dout_valid <= 1'b1;
                    clk_enable <= 1'b0;
                end
            end
            OUTPUT: begin
                // Output the parallel data
                next_state <= IDLE;
                cnt <= 3'b000;
                dout_valid <= 1'b0;
            end
            default: next_state <= IDLE;
        endcase
    end
end

endmodule