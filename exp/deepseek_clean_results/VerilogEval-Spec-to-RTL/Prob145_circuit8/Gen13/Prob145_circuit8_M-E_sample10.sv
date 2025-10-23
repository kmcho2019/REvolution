module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;  // State machine to track previous a values
reg p_next;       // Next value for p

initial begin
    state = 2'b00;
    p = 1'bx;
    q = 1'bx;
    p_next = 1'bx;
end

always @(posedge clock) begin
    if (state === 2'bxx) begin
        state <= 2'b00;
        p <= 0;
        q <= 0;
    end else begin
        // Update state machine
        state <= {state[0], a};
        
        // Update p based on current state and q
        if (~q) begin
            p <= p_next;
        end else begin
            p <= 0;
        end
        
        // Set q if we've seen a full cycle with a=1
        if (state == 2'b11) begin
            q <= 1;
        end
    end
end

always @(negedge clock) begin
    if (state !== 2'bxx) begin
        // Reset q if a is high during falling edge
        if (a) begin
            q <= 0;
        end
        
        // Determine next p value
        if (~q) begin
            p_next <= a & state[0];
        end else begin
            p_next <= 0;
        end
    end
end

endmodule