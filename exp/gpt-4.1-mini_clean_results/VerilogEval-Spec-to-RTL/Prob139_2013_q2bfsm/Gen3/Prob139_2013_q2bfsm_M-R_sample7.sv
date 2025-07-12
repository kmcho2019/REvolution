module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // One-hot states encoding
    localparam [7:0]
        A  = 8'b0000_0001, // reset state
        B  = 8'b0000_0010, // f=1 one cycle after reset release
        C  = 8'b0000_0100, // monitoring sequence on x input
        D  = 8'b0000_1000, // g=1, monitor y for 2 cycles
        E  = 8'b0001_0000, // permanent g=1 (success)
        F  = 8'b0010_0000; // permanent g=0 (failure)

    reg [7:0] state, next_state;

    // Shift register to capture last 3 bits of x for sequence detection
    reg [2:0] x_seq;

    // Counter for monitoring y input up to 2 cycles
    reg [1:0] y_count;

    // Synchronous state and counters update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_seq   <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_seq only in sequence monitoring state C,
            // else clear it to avoid false positives after reset or other states.
            if (state == C) begin
                x_seq <= {x_seq[1:0], x};
            end else begin
                x_seq <= 3'b000;
            end

            // Update y_count only in D state, reset otherwise
            if (state == D) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default: hold current state
        next_state = state;

        case (state)
            A: begin
                // Stay in A while reset asserted
                if (resetn)
                    next_state = B;
            end

            B: begin
                // One cycle f=1 done, go start sequence detection
                next_state = C;
            end

            C: begin
                // Monitor x sequence: wait for pattern 1,0,1 in x_seq
                // Pattern bits: x_seq[2:0] == 3'b101
                if (x_seq == 3'b101)
                    next_state = D;
                else
                    next_state = C; // keep detecting
            end

            D: begin
                // g=1, monitor y for up to 2 cycles
                if (y == 1'b1)
                    next_state = E; // success: permanent g=1
                else if (y_count == 2'd2)
                    next_state = F; // failure: permanent g=0
                else
                    next_state = D; // keep monitoring
            end

            E: begin
                // permanent g=1
                next_state = E;
            end

            F: begin
                // permanent g=0
                next_state = F;
            end

            default: next_state = A;
        endcase
    end

    // Output logic combinational based on current state
    assign f = (state == B);
    assign g = (state == D) || (state == E);

endmodule