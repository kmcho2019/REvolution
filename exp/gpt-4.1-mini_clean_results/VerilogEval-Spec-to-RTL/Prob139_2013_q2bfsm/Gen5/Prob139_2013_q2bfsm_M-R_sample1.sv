module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

// One-hot state encoding for clarity
localparam A  = 7'b0000001; // Reset state
localparam B  = 7'b0000010; // f=1 pulse after reset release
localparam C1 = 7'b0000100; // wait for x=1
localparam C2 = 7'b0001000; // wait for x=0
localparam C3 = 7'b0010000; // wait for x=1
localparam D  = 7'b0100000; // g=1 and monitor y
localparam E  = 7'b1000000; // permanent success (g=1)
localparam F  = 7'b0000000; // permanent failure (g=0) - use 0 state for clarity

reg [6:0] state, next_state;
reg [1:0] d_count; // counts cycles in D, max 2 cycles

// State transition and counter logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        d_count <= 2'd0;
    end else begin
        state <= next_state;
        // Manage d_count only when in or entering D
        if (state != D && next_state == D)
            d_count <= 2'd1; // start counting from 1 on first cycle in D
        else if (state == D)
            d_count <= d_count + 1'b1;
        else
            d_count <= 2'd0;
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        A: begin
            // Stay in A while reset asserted
            if (resetn)
                next_state = B;
        end
        B: begin
            // One cycle pulse of f, then start sequence detection
            next_state = C1;
        end
        C1: begin
            // Wait for x=1 to proceed
            if (x)
                next_state = C2;
            else
                next_state = C1;
        end
        C2: begin
            // Wait for x=0 to proceed
            if (!x)
                next_state = C3;
            else
                next_state = C2; // stay waiting if x=1
        end
        C3: begin
            // Wait for x=1 to proceed to D or else restart at C1
            if (x)
                next_state = D;
            else
                next_state = C1;
        end
        D: begin
            // g=1 and monitor y for at most 2 cycles
            if (y)
                next_state = E; // success
            else if (d_count == 2)
                next_state = F; // failure after 2 cycles without y=1
            else
                next_state = D;
        end
        E: begin
            // Permanent success
            next_state = E;
        end
        F: begin
            // Permanent failure
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Output combinational logic from state (one-hot encoding)
assign f = (state == B);
assign g = (state == D) || (state == E);

endmodule