module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

// One-hot state encoding - all states have exactly one bit set
localparam [7:0]
    A  = 8'b0000_0001, // Reset state
    B  = 8'b0000_0010, // f=1 pulse after reset release (1 cycle)
    C1 = 8'b0000_0100, // Wait for x=1
    C2 = 8'b0000_1000, // Wait for x=0
    C3 = 8'b0001_0000, // Wait for x=1
    D  = 8'b0010_0000, // g=1 and monitor y (up to 2 cycles)
    E  = 8'b0100_0000, // Permanent success (g=1)
    F  = 8'b1000_0000; // Permanent failure (g=0)

reg [7:0] state, next_state;
reg [1:0] d_count; // counts cycles in D (0..2)

// Sequential logic for state and counter
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        d_count <= 2'd0;
    end else begin
        state <= next_state;

        // Manage d_count only in state D
        if (next_state == D) begin
            if (state != D) begin
                d_count <= 2'd0; // reset counter on entering D
            end else begin
                d_count <= d_count + 1'b1; // increment in D
            end
        end else begin
            d_count <= 2'd0; // reset counter outside D
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        A: begin
            // Stay in A while resetn=0
            if (resetn)
                next_state = B; // go to pulse f after reset release
        end

        B: begin
            // One cycle pulse of f, then start sequence detection
            next_state = C1;
        end

        C1: begin
            // Wait for x=1; if x=1 advance, else stay in C1
            if (x)
                next_state = C2;
            else
                next_state = C1;
        end

        C2: begin
            // Wait for x=0; if x=0 advance, else if x=1 stay in C2
            if (!x)
                next_state = C3;
            else
                next_state = C2;
        end

        C3: begin
            // Wait for x=1; if x=1 advance to D else restart at C1
            if (x)
                next_state = D;
            else
                next_state = C1;
        end

        D: begin
            // Assert g=1; monitor y for up to 2 cycles
            if (y)
                next_state = E;        // success: permanent g=1
            else if (d_count == 2)
                next_state = F;        // failure: permanent g=0
            else
                next_state = D;        // continue monitoring
        end

        E: begin
            // Permanent success
            next_state = E;
        end

        F: begin
            // Permanent failure
            next_state = F;
        end

        default: next_state = A; // should not occur but safe fallback
    endcase
end

// Output combinational logic from state
assign f = (state == B);
assign g = (state == D) || (state == E);

endmodule