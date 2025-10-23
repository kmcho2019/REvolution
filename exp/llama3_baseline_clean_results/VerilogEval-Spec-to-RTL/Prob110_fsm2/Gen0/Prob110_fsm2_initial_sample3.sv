module TopModule (
    input        clk,
    input        areset,
    input        j,
    input        k,
    output       out
);

reg [1:0] state; // Using 2 bits to represent two states, OFF and ON
parameter OFF = 2'b00, ON = 2'b01;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        // Asynchronous reset to the OFF state
        state <= OFF;
    end else begin
        // State transition logic
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // Default to OFF state for invalid states
        endcase
    end
end

always @(*) begin
    // Output logic
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // Default output to 0 for invalid states
    endcase
end

endmodule