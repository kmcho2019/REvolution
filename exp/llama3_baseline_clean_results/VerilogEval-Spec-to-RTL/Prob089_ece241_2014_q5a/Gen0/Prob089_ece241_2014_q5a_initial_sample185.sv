module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [1:0] state; // Idle, Accumulate, Complement
reg [31:0] acc; // Accumulator for input number
reg [31:0] comp; // Register to hold the complement
reg invert; // Flag to indicate inversion phase
reg add_one; // Flag to indicate add one phase

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to idle state
        acc <= 32'd0; // Reset accumulator
        comp <= 32'd0; // Reset complement
        invert <= 1'b0; // Reset invert flag
        add_one <= 1'b0; // Reset add one flag
    end else begin
        case(state)
            2'b00: begin // Idle state
                if(!areset) begin
                    state <= 2'b01; // Move to accumulate state
                    acc <= 32'd0; // Reset accumulator
                    comp <= 32'd0; // Reset complement
                    invert <= 1'b1; // Set invert flag
                    add_one <= 1'b0; // Reset add one flag
                end
            end
            2'b01: begin // Accumulate state
                if(areset) begin
                    state <= 2'b00; // Return to idle state
                end else begin
                    acc = {acc[30:0], x}; // Shift and add input bit
                    if(invert) begin
                        state <= 2'b10; // Move to complement state
                        comp = ~acc; // Invert bits
                        invert <= 1'b0; // Reset invert flag
                        add_one <= 1'b1; // Set add one flag
                    end
                end
            end
            2'b10: begin // Complement state
                if(areset) begin
                    state <= 2'b00; // Return to idle state
                end else begin
                    comp = comp + 1; // Add 1 to get 2's complement
                    state <= 2'b11; // Move to output state
                end
            end
            2'b11: begin // Output state
                if(areset) begin
                    state <= 2'b00; // Return to idle state
                end else begin
                    z = comp[0]; // Output least significant bit of complement
                    comp = comp >> 1; // Shift out the output bit
                    if(comp == 32'd0) begin
                        state <= 2'b01; // Return to accumulate state
                    end
                end
            end
        endcase
    end
end

endmodule