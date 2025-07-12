module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define states
enum logic [1:0] {IDLE, CONVERT} state, next_state;

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Data register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and counters
        state <= IDLE;
        cnt <= 2'b00;
        data <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (cnt == 2'b11) begin
                    // Transition to CONVERT state
                    state <= CONVERT;
                    cnt <= 2'b00;
                    data <= d;
                end else begin
                    // Stay in IDLE state and increment counter
                    state <= IDLE;
                    cnt <= cnt + 1'b1;
                end
            end
            CONVERT: begin
                if (cnt == 2'b11) begin
                    // Transition back to IDLE state
                    state <= IDLE;
                    cnt <= 2'b00;
                end else begin
                    // Stay in CONVERT state and increment counter
                    state <= CONVERT;
                    cnt <= cnt + 1'b1;
                end
            end
        endcase
    end
end

// Assign valid signal based on state
assign valid_out = (state == CONVERT);
// Assign most significant bit of data to output based on counter
assign dout = data[3 - cnt];

// Shift data register
always @ (posedge clk) begin
    if (state == CONVERT) begin
        data <= {data[2:0], 1'b0};
    end
end

endmodule