module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received
reg [1:0] state; // 2-bit state register (IDLE, RECEIVE)

// Define the states
localparam IDLE = 2'b00;
localparam RECEIVE = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state, counter, output, and validity signal
        state <= IDLE;
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (din_valid) begin
                    // Transition to RECEIVE state
                    state <= RECEIVE;
                    cnt <= 4'b0001;
                    dout_parallel <= {7'b0000000, din_serial};
                end
            end
            RECEIVE: begin
                if (cnt < 4'b1000) begin
                    // Shift in the new data and increment the counter
                    cnt <= cnt + 1'b1;
                    dout_parallel <= {dout_parallel[6:0], din_serial};
                end else begin
                    // Set the output valid signal to 1 and transition back to IDLE state
                    dout_valid <= 1'b1;
                    state <= IDLE;
                end
            end
            default: begin
                // Default state (should not occur)
                state <= IDLE;
            end
        endcase
    end
end

// Assign output signals
assign dout_valid = (state == RECEIVE && cnt == 4'b1000) ? 1'b1 : 1'b0;

endmodule