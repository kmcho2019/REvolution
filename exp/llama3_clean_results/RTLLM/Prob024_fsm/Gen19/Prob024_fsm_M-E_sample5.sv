module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Encode states for sequence detection
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

reg [1:0] current_state, next_state;

// Initial state on reset
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// State machine logic
always @(*) begin
    case(current_state)
        S0: begin
            if(IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if(!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if(!IN) begin
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if(IN) begin
                next_state = S3; // Match condition, assert MATCH
            end else begin
                next_state = S0; // Reset to initial state on mismatch
            end
        end
        default: next_state = S0;
    endcase
end

// Assert MATCH when in the final state (S3) and input is 1
assign MATCH = (current_state == S3 && IN);

endmodule