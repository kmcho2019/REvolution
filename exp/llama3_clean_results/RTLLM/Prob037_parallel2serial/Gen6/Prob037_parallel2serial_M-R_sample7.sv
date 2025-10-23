module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] data;                  // Internal data register
reg [1:0] cnt;                   // Internal counter
reg         valid;               // Internal valid signal
reg [1:0] state;                 // State register for FSM

// Assign valid signal based on state
assign valid_out = (state == 2'b00)? 1 : 0;
assign dout = data[3];           // Assign most significant bit of data to output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers and signals
        data <= 4'b0000;
        cnt <= 2'b00;
        state <= 2'b01;           // Initialize to idle state
    end else begin
        case (state)
            2'b01: begin         // Idle state
                if (cnt == 3) begin
                    state <= 2'b00;   // Transition to output state
                    data <= d;         // Load new data
                    cnt <= 2'b00;      // Reset counter
                end else begin
                    cnt <= cnt + 1;    // Increment counter
                end
            end
            2'b00: begin         // Output state
                if (cnt == 3) begin
                    state <= 2'b01;   // Transition back to idle state
                    cnt <= 2'b00;      // Reset counter
                end else begin
                    cnt <= cnt + 1;    // Increment counter
                    data <= {data[2:0], data[3]}; // Shift data
                end
            end
            default: begin
                state <= 2'b01;       // Default to idle state
            end
        endcase
    end
end

endmodule