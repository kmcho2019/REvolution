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
                    state <= 2'b01; // MATCH_1 state
                end
            2'b01: // MATCH_1 state
                if (!x) begin
                    state <= 2'b10; // MATCH_10 state
                end else begin
                    state <= 2'b01; // Stay in MATCH_1 state
                end
            2'b10: // MATCH_10 state
                if (x) begin
                    state <= 2'b00; // Reset to IDLE state
                end else begin
                    state <= 2'b10; // Stay in MATCH_10 state
                end
            default:
                state <= 2'b00; // Reset to IDLE state
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule