module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Reg to hold the current state
reg current_state;

// Output is determined by the current state
assign out = current_state;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to OFF state
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: begin
                current_state <= OFF; // Default to OFF state if unknown
            end
        endcase
    end
end

endmodule