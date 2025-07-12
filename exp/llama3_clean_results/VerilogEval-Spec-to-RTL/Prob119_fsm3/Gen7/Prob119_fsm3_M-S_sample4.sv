module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values
reg [1:0] state;

// Sequential logic for state transition and output
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to state A
        out <= 1'b0;    // Initialize output
    end else begin
        case (state)
            2'b00: begin // State A
                state <= in? 2'b01 : 2'b00;
                out <= 1'b0;
            end
            2'b01: begin // State B
                state <= in? 2'b01 : 2'b10;
                out <= 1'b0;
            end
            2'b10: begin // State C
                state <= in? 2'b11 : 2'b00;
                out <= 1'b0;
            end
            2'b11: begin // State D
                state <= in? 2'b01 : 2'b10;
                out <= 1'b1;
            end
        endcase
    end
end

endmodule