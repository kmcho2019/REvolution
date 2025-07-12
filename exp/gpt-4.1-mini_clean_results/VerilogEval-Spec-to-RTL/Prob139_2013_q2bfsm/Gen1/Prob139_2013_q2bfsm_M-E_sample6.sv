module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding
localparam [2:0]
    A  = 3'd0, // reset state
    B  = 3'd1, // f=1 one cycle after reset released
    C1 = 3'd2, // waiting for x=1 (start sequence)
    C2 = 3'd3, // waiting for x=0 after x=1
    C3 = 3'd4, // waiting for x=1 after 1,0
    D  = 3'd5, // g=1, monitor y up to 2 cycles
    E  = 3'd6, // permanent g=1 success
    F  = 3'd7; // permanent g=0 failure

reg [2:0] state, next_state;
reg [1:0] d_count; // counter for 2-cycle monitoring in D

// State register and counter
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        d_count <= 2'd0;
    end else begin
        state <= next_state;
        // Count only in state D
        if (state == D) begin
            d_count <= d_count + 1'b1;
        end else begin
            d_count <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold
    
    case(state)
        A: begin
            // Wait for reset release
            if (resetn)
                next_state = B;
        end

        B: begin
            // After outputting f=1 for one cycle, go to sequence detection
            next_state = C1;
        end

        C1: begin
            // Wait for x=1 to start sequence
            if (x == 1'b1)
                next_state = C2;
            else
                next_state = C1; // stay waiting
        end

        C2: begin
            // Wait for x=0 next
            if (x == 1'b0)
                next_state = C3;
            else if (x == 1'b1)
                // sequence broken, restart looking for first 1
                next_state = C2; // remain in C2 since x=1 again means wait for 0 after 1
            else
                next_state = C1; // if x invalid (should be 0 or 1), reset sequence (safe fallback)
        end

        C3: begin
            // Wait for x=1 to complete sequence
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                // sequence broken, restart from beginning looking for x=1
                next_state = C1;
            else
                next_state = C1; // safe fallback
        end

        D: begin
            // g=1 and monitor y for up to 2 cycles
            if (y == 1'b1) begin
                next_state = E; // permanent success
            end else if (d_count == 2'd2) begin
                // waited 2 cycles, no y=1, failure
                next_state = F;
            end else begin
                next_state = D; // keep monitoring
            end
        end

        E: begin
            // permanent success until reset
            next_state = E;
        end

        F: begin
            // permanent failure until reset
            next_state = F;
        end

        default: next_state = A;
    endcase
end

// Output logic (Moore outputs registered)
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f=1 exactly one cycle in state B, else 0
        f <= (next_state == B) ? 1'b1 : 1'b0;

        // g=1 in D and E; 0 otherwise
        if (next_state == D || next_state == E)
            g <= 1'b1;
        else
            g <= 1'b0;
    end
end

endmodule