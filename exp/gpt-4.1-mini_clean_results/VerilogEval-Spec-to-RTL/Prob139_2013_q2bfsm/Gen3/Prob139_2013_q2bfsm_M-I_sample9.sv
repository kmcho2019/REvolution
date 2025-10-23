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
    B  = 3'd1, // f=1 one cycle after reset release
    C1 = 3'd2, // waiting for x=1 (start sequence)
    C2 = 3'd3, // waiting for x=0 after x=1 detected
    C3 = 3'd4, // waiting for x=1 after 1,0 detected
    D  = 3'd5, // g=1, monitor y up to 2 cycles
    E  = 3'd6, // permanent g=1 success
    F  = 3'd7; // permanent g=0 failure

reg [2:0] state, next_state;
reg [1:0] d_count; // counts cycles spent in D state (0..2)

// Sequential logic for state and d_count
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        d_count <= 2'd0;
    end else begin
        // state updates
        if (state != D && next_state == D) begin
            // entering D: reset counter
            d_count <= 2'd0;
        end else if (state == D) begin
            d_count <= d_count + 1'b1;
        end else begin
            d_count <= 2'd0;
        end
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold
    
    case(state)
        A: begin
            // Stay here as long as resetn==0
            if (resetn)
                next_state = B;
        end

        B: begin
            // After reset release, output f=1 one cycle, then sequence detection
            next_state = C1;
        end

        C1: begin
            // Wait for x=1 to start sequence
            if (x == 1'b1)
                next_state = C2;
            else
                next_state = C1;
        end

        C2: begin
            // Wait for x=0 after detecting 1
            if (x == 1'b0)
                next_state = C3;
            else if (x == 1'b1)
                next_state = C2;
            else
                next_state = C2; // safe default (shouldn't happen)
        end

        C3: begin
            // Wait for x=1 to complete 1,0,1 sequence
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                next_state = C1; // restart sequence detection on failure
            else
                next_state = C1; // safe fallback
        end

        D: begin
            // Monitor y for up to 2 cycles starting when entering D (d_count counts cycles in D)
            if (y == 1'b1)
                next_state = E; // success
            else if (d_count == 2)
                next_state = F; // failure after 2 cycles without y==1
            else
                next_state = D; // keep monitoring
        end

        E: begin
            // Permanent success state, g=1
            next_state = E;
        end

        F: begin
            // Permanent failure state, g=0
            next_state = F;
        end

        default: next_state = A;
    endcase
end

// Output logic (registered), outputs driven from current state
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f=1 only for one cycle in state B, else 0
        f <= (state == B) ? 1'b1 : 1'b0;

        // g=1 in states D (monitoring) and E (permanent success), else 0
        g <= (state == D || state == E) ? 1'b1 : 1'b0;
    end
end

endmodule