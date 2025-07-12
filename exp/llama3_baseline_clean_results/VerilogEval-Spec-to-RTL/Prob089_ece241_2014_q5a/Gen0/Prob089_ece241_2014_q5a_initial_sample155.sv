module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // Idle, Operational, Invert
reg [1:0] nextState;
reg [31:0] count; // Counter for bits
reg addOne; // Flag to indicate addition of 1
reg [31:0] result; // Store the result

// Reset to idle state on asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to idle state
        count <= 32'd0;
        result <= 32'd0;
        addOne <= 1'b0;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Idle state
            if(!areset) begin
                nextState <= 2'b01; // Move to operational state
            end else begin
                nextState <= 2'b00;
            end
        end
        2'b01: begin // Operational state
            if(x) begin // Input is '1'
                nextState <= 2'b01; // Continue in operational state
            end else begin // Input is '0'
                nextState <= 2'b10; // Move to inverting state
            end
        end
        2'b10: begin // Inverting state
            if(count == 32'd0) begin // All bits inverted, add 1
                nextState <= 2'b00; // Return to idle
                addOne <= 1'b1;
            end else begin
                nextState <= 2'b10; // Stay in inverting state
            end
        end
    endcase
end

always @(posedge clk) begin
    if(state == 2'b01) begin // Operational state
        result <= {result[30:0], x}; // Shift in input
        count <= count + 1'b1; // Increment bit count
    end else if(state == 2'b10) begin // Inverting state
        result <= {result[30:0], ~x}; // Invert input and shift in
        count <= count - 1'b1; // Decrement bit count
    end
end

assign z = (addOne && (count == 32'd0)) ? 1'b1 : result[0]; // Output based on state and result

endmodule