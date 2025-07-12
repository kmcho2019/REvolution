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
reg         idle;                 // State variable for idle state

// State machine
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers and signals
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
        idle <= 1'b1;
    end else if (idle && cnt == 3) begin
        // Transition from idle to conversion state
        data <= d;
        cnt <= 2'b00;
        valid <= 1'b1;
        idle <= 1'b0;
    end else if (!idle) begin
        // Conversion state
        if (cnt < 3) begin
            // Increment counter and shift data register
            cnt <= cnt + 1;
            data <= {data[2:0], data[3]};
            valid <= 1'b1;
        end else begin
            // Transition back to idle state
            idle <= 1'b1;
            valid <= 1'b0;
        end
    end
end

// Assignments
assign valid_out = valid;
assign dout = data[3];

endmodule