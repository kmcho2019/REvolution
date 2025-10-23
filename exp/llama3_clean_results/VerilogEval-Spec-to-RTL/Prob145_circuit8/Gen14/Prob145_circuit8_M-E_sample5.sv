module TopModule(
    input clock,
    input a,
    output reg p = 1'b0,
    output reg q = 1'b0
);

reg [2:0] state = 3'b000; // Idle state
reg [2:0] counter = 3'b000; // Counter for clock cycles

always @(posedge clock) begin
    case (state)
        3'b000: begin // Idle state
            if (a) begin
                state <= 3'b001; // Transition to state where p is high
                p <= 1'b1;
                q <= 1'b0;
            end
        end
        3'b001: begin // State where p is high
            if (~a) begin
                state <= 3'b000; // Transition back to idle state
                p <= 1'b0;
                q <= 1'b0;
            end else if (counter == 3'b111) begin // Counter reaches threshold
                state <= 3'b010; // Transition to state where both p and q are high
                p <= 1'b1;
                q <= 1'b1;
            end else begin
                counter <= counter + 1'b1; // Increment counter
            end
        end
        3'b010: begin // State where both p and q are high
            if (~a) begin
                state <= 3'b000; // Transition back to idle state
                p <= 1'b0;
                q <= 1'b0;
                counter <= 3'b000; // Reset counter
            end
        end
        default: begin
            state <= 3'b000; // Reset to idle state
            p <= 1'b0;
            q <= 1'b0;
        end
    endcase
end

always @(negedge clock) begin
    if (a) begin
        state <= 3'b000; // Transition back to idle state
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule