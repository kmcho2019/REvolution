module TopModule(
    input clock,
    input a,
    output reg p = 1'b0,
    output reg q = 1'b0
);

reg [1:0] state = 2'b00; // Initialize state to S0 (00)

always @(posedge clock) begin
    case (state)
        2'b00: begin // S0
            if (a) begin
                state <= 2'b01; // Transition to S1
                p <= 1'b1; // Set p high
            end
        end
        2'b01: begin // S1
            p <= a; // Update p based on a
            if (!a) begin
                state <= 2'b00; // Transition back to S0
            end
        end
        default: state <= 2'b00; // Default to S0
    endcase
end

always @(negedge clock) begin
    case (state)
        2'b01: begin // S1
            if (a) begin
                q <= 1'b0; // Reset q when a is high in S1
            end else begin
                q <= p; // Update q based on p in S1
            end
        end
        default: ; // No action in other states
    endcase
end

endmodule