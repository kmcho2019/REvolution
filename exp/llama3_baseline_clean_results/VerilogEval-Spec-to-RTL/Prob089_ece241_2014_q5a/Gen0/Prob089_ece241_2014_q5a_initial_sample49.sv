module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] state; // This will store the accumulated bits
reg [31:0] next_state; // This will store the next state value
reg out_temp; // This will store the temporary output value
assign z = out_temp; // The output is directly taken from the current state

// Initial block to handle asynchronous reset
initial begin
    state = 32'd0;
    out_temp = 1'b0;
end

// Combinational logic to compute the next state
always @(*) begin
    if (areset) begin
        next_state = 32'd0;
    end else begin
        next_state = {state[30:0], x}; // Shift the current state left by one bit and add the new input bit
    end
end

// Combinational logic to compute the output
always @(*) begin
    if (areset) begin
        out_temp = 1'b0;
    end else if (state[31]) begin // If the most significant bit is '1', it means we are computing the 2's complement
        out_temp = ~(state[0]) + 1'b1; // Compute the 2's complement of the least significant bit
    end else begin
        out_temp = state[0]; // Otherwise, the output is the same as the least significant bit of the current state
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 32'd0;
        out_temp <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule