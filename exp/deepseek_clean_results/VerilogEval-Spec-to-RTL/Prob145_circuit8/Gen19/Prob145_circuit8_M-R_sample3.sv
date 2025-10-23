module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state; // 0=IDLE, 1=ACTIVE
reg prev_a;

always @(posedge clock) begin
    // State transition logic
    case (state)
        1'b0: state <= (a) ? 1'b1 : 1'b0; // IDLE -> ACTIVE when a=1
        1'b1: state <= (prev_a & ~a) ? 1'b0 : 1'b1; // ACTIVE -> IDLE on falling a
    endcase
    
    // Store previous a value for edge detection
    prev_a <= a;
end

always @(posedge clock) begin
    // p generation
    if (state) begin
        p <= a; // Sample a when in ACTIVE state
    end else begin
        p <= 1'b0; // IDLE state
    end
    
    // q generation (always 1-cycle delayed p)
    q <= p;
end

initial begin
    state = 1'b0;
    prev_a = 1'b0;
    p = 1'b0;
    q = 1'b0;
end

endmodule