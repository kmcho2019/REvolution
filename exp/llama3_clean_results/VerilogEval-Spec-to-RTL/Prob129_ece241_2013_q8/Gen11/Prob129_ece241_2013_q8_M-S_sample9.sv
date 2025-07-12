module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // IDLE state
    end else begin
        case(state)
            2'b00: // IDLE state
                if (x) begin
                    state <= 2'b01; // FOUND_10 state
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                end
            2'b01: // FOUND_10 state
                if (x) begin
                    state <= 2'b10; // FOUND_101 state
                end else begin
                    state <= 2'b00; // Go back to IDLE state
                end
            2'b10: // FOUND_101 state
                state <= 2'b00; // Go back to IDLE state
        endcase
    end
end

// Output logic
assign z = (state == 2'b10);

endmodule