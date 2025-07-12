module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

// State encoding
typedef enum logic [2:0] {
    A  = 3'd0, // reset state
    B  = 3'd1, // output f=1 one cycle after reset release
    C1 = 3'd2, // sequence detect: expecting x=1
    C2 = 3'd3, // sequence detect: expecting x=0 after 1
    C3 = 3'd4, // sequence detect: expecting x=1 after 1,0
    D  = 3'd5, // g=1, monitor y up to 2 cycles
    E  = 3'd6, // permanent success (g=1)
    F  = 3'd7  // permanent failure (g=0)
} state_t;

state_t state, next_state;

// Counter for cycles spent in D (monitor y)
logic [1:0] d_count;
logic d_count_reset, d_count_inc;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        d_count <= 2'd0;
    end else begin
        state <= next_state;
        if (d_count_reset)
            d_count <= 2'd0;
        else if (d_count_inc)
            d_count <= d_count + 2'd1;
        else
            d_count <= d_count;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    d_count_reset = 1'b0;
    d_count_inc = 1'b0;

    case (state)
        A: begin
            if (resetn)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            // After f=1 pulse, start sequence detection
            next_state = C1;
        end
        C1: begin
            // Waiting for x=1
            if (x == 1'b1)
                next_state = C2;
            else
                next_state = C1;
        end
        C2: begin
            // Waiting for x=0
            if (x == 1'b0)
                next_state = C3;
            else if (x == 1'b1)
                next_state = C2; // stay here waiting for zero after 1
            else
                next_state = C2; // defensive
        end
        C3: begin
            // Waiting for x=1 to complete sequence 1,0,1
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                next_state = C1; // restart if pattern fails
            else
                next_state = C1; // fallback
        end
        D: begin
            // On entry to D reset counter
            d_count_reset = (state != D);

            // Counting cycles in D
            d_count_inc = 1'b1;

            // Check if y==1 within 2 cycles
            if (y == 1'b1)
                next_state = E;
            else if (d_count == 2)
                next_state = F;
            else
                next_state = D;
        end
        E: begin
            next_state = E; // permanent success
        end
        F: begin
            next_state = F; // permanent failure
        end
        default: next_state = A;
    endcase
end

// Output logic driven combinationally from current state
assign f = (state == B);
assign g = (state == D) || (state == E);

endmodule