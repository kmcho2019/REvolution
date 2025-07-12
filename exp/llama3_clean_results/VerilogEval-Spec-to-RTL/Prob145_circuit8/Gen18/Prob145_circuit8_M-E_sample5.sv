module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // FSM state: 2'b00 for IDLE, 2'b01 for ACTIVE
reg next_state; // Next state of the FSM

// Output logic
always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            p = 1'b0;
            q = 1'b0;
        end
        2'b01: begin // ACTIVE state
            if (clock) begin
                p = a;
                if (a) begin
                    q = 1'b1;
                end else begin
                    q = q; // Stay in the current state for q
                end
            end else begin // Negative clock phase
                if (a) begin
                    q = 1'b0; // Reset q when a is high during negative phase
                end else begin
                    q = q; // Stay in the current state for q
                end
            end
        end
        default: begin
            p = 1'b0;
            q = 1'b0;
        end
    endcase
end

// Next state logic
always @(posedge clock) begin
    if (a) begin
        state = 2'b01; // Transition to ACTIVE state
    end else begin
        state = 2'b00; // Stay in IDLE state
    end
end

endmodule