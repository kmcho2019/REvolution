module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] state;                 // State machine state
reg [3:0] data_buf;              // Data buffer to store input parallel data
reg [1:0] shift_cnt;             // Shift counter

// State machine states
localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam SHIFT = 2'b10;
localparam DONE = 2'b11;

// Sequential logic for state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state machine on reset
        state <= IDLE;
        data_buf <= 4'b0000;
        shift_cnt <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                // Wait for new input data
                if (d != 4'b0000) begin
                    // Load input data into buffer
                    data_buf <= d;
                    state <= LOAD;
                end
            end
            LOAD: begin
                // Transition to SHIFT state
                state <= SHIFT;
            end
            SHIFT: begin
                // Shift out bits of stored data
                if (shift_cnt == 2'b11) begin
                    // All bits shifted out, transition to DONE state
                    state <= DONE;
                end else begin
                    // Increment shift counter
                    shift_cnt <= shift_cnt + 1'b1;
                end
            end
            DONE: begin
                // Reset state machine
                state <= IDLE;
                data_buf <= 4'b0000;
                shift_cnt <= 2'b00;
            end
        endcase
    end
end

// Assign valid signal based on state
assign valid_out = (state == SHIFT || state == DONE);

// Assign bit from data buffer based on shift counter
assign dout = data_buf[3 - shift_cnt];

endmodule