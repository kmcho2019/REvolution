module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset and sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00; // IDLE state
    end else begin
        case (state)
            2'b00: // IDLE state
                if (x) begin
                    state <= 2'b01; // ONE state
                end
            2'b01: // ONE state
                if (!x) begin
                    state <= 2'b10; // ONE_ZERO state
                end else begin
                    state <= 2'b01; // Stay in ONE state
                end
            2'b10: // ONE_ZERO state
                if (x) begin
                    state <= 2'b00; // IDLE state
                    z <= 1'b1; // Assert output z
                end else begin
                    state <= 2'b10; // Stay in ONE_ZERO state
                end
            default: state <= 2'b00; // Default to IDLE state
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (state == 2'b10 && x) begin
        z <= 1'b1; // Assert output z
    end else begin
        z <= 1'b0; // Deassert output z
    end
end

endmodule