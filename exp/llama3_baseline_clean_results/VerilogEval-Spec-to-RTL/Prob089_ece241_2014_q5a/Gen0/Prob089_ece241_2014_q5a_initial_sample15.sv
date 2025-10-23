module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0 - IDLE, 1 - CONVERT
reg invert; // flag to indicate whether to invert the bits or not
reg [31:0] bits_received; // register to store the bits received so far
reg [31:0] two_complement; // register to store the 2's complement

// Initialize the state machine to the IDLE state
initial begin
    state = 0;
    invert = 0;
    bits_received = 0;
    two_complement = 0;
end

// Asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        invert <= 0;
        bits_received <= 0;
        two_complement <= 0;
    end else if (state == 0) begin
        // Stay in IDLE state until the first bit is received
        if (x) begin
            state <= 1;
            bits_received <= {31'd0, 1'b1};
            two_complement <= 1;
        end
    end else if (state == 1) begin
        // In the CONVERT state, shift in the new bit and calculate the 2's complement
        bits_received <= {bits_received[30:0], x};
        if (x) begin
            two_complement <= {two_complement[30:0], ~x};
        end else begin
            two_complement <= {two_complement[30:0], ~x};
        end
        // Set the invert flag when the first bit is 1
        if (bits_received[31]) begin
            invert <= 1;
        end
    end
end

// Generate the output (Z) based on the current state and the input (x)
always @(*) begin
    if (state == 0) begin
        z = 1'b0;
    end else if (state == 1) begin
        if (invert) begin
            z = ~x;
        end else begin
            z = x;
        end
    end
end

endmodule