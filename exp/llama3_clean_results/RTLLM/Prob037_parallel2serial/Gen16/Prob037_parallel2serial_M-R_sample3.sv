module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define states
enum logic [1:0] {
    IDLE,
    SHIFT
} state, next_state;

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Data register

// Assign valid signal based on counter value
assign valid_out = (state == SHIFT)? 1 : 0;  

// Assign most significant bit of data to output based on counter
assign dout = data[3];          

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state, counter, and data
        state <= IDLE;
        cnt <= 2'b00;
        data <= 4'b0000;
    end else begin
        // Update state, counter, and data
        case (state)
            IDLE: begin
                if (cnt == 3) begin
                    state <= IDLE;
                    cnt <= 2'b00;
                    data <= d;
                end else begin
                    state <= SHIFT;
                    cnt <= cnt + 1;
                    data <= d;
                end
            end
            SHIFT: begin
                if (cnt == 3) begin
                    state <= IDLE;
                    cnt <= 2'b00;
                    data <= data;
                end else begin
                    state <= SHIFT;
                    cnt <= cnt + 1;
                    data <= {data[2:0], data[3]};
                end
            end
            default: begin
                state <= IDLE;
                cnt <= 2'b00;
                data <= 4'b0000;
            end
        endcase
    end
end

endmodule