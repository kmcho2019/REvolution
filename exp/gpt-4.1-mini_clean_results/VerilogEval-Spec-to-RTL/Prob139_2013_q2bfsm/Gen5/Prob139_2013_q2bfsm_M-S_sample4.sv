module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding
typedef enum reg [3:0] {
    A  = 4'd0, // reset
    B  = 4'd1, // f=1 pulse after reset release
    C1 = 4'd2, // wait x=1
    C2 = 4'd3, // wait x=0
    C3 = 4'd4, // wait x=1
    D0 = 4'd5, // g=1, monitor y cycle 0
    D1 = 4'd6, // g=1, monitor y cycle 1
    D2 = 4'd7, // g=1, monitor y cycle 2
    E  = 4'd8, // permanent g=1
    F  = 4'd9  // permanent g=0
} state_t;

state_t state, next_state;

// Sequential state update with synchronous active low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case(state)
        A: if (resetn) next_state = B; else next_state = A;
        B: next_state = C1;

        // Detect x sequence 1,0,1
        C1: next_state = (x == 1'b1) ? C2 : C1;
        C2: next_state = (x == 1'b0) ? C3 :
                         (x == 1'b1) ? C2 : C2; // stay if not 0 or 1, treating unknown as 1
        C3: next_state = (x == 1'b1) ? D0 :
                         (x == 1'b0) ? C1 : C1; // restart sequence if failed

        // Monitor y up to 2 cycles with g=1
        D0: if (y == 1'b1) next_state = E; else next_state = D1;
        D1: if (y == 1'b1) next_state = E; else next_state = D2;
        D2: if (y == 1'b1) next_state = E; else next_state = F;

        // Permanent output states
        E: next_state = E;
        F: next_state = F;

        default: next_state = A;
    endcase
end

// Output logic (registered)
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        f <= (state == B);
        g <= (state == D0) || (state == D1) || (state == D2) || (state == E);
    end
end

endmodule