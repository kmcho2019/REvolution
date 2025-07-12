module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    localparam
        A            = 3'd0, // reset state, outputs f=0 g=0
        B            = 3'd1, // f=1 one cycle after reset deassert
        C            = 3'd2, // wait for pattern 1,0,1 on x (3 successive samples)
        D            = 3'd3, // one cycle g=1 after pattern detected
        E            = 3'd4, // monitor y up to 2 cycles with g=1
        F            = 3'd5, // g=1 permanently
        G            = 3'd6; // g=0 permanently

    reg [2:0] state, next_state;

    // Shift register for x samples in state C
    reg [2:0] x_shift;

    // y monitoring counter for state E
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state, x_shift, y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Shift in x only in state C
            if (state == C)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            y_count <= next_y_count;
        end
    end

    // Next state and y_count combinational logic
    always @(*) begin
        // defaults
        next_state = state;
        next_y_count = y_count;

        case (state)
            A: begin
                // Wait in A while resetn=0 (reset handled synchronously)
                // When resetn=1, next clock move to B (f=1 pulse)
                next_state = B;
                next_y_count = 2'd0;
            end
            B: begin
                // f=1 one cycle
                next_state = C;
                next_y_count = 2'd0;
            end
            C: begin
                // Wait for pattern 101 on x_shift
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
                next_y_count = 2'd0;
            end
            D: begin
                // One cycle g=1 right after pattern detected
                // Then go to Y monitoring for up to 2 cycles
                next_state = E;
                next_y_count = 2'd0;
            end
            E: begin
                // g=1, monitor y for at most 2 cycles (y_count=0 or 1)
                if (y == 1'b1)
                    next_state = F;   // y=1 detected, g=1 permanently
                else if (y_count == 2'd1)
                    next_state = G;   // 2 cycles elapsed, y=0, g=0 permanently
                else begin
                    // increment y_count and stay in E
                    next_state = E;
                    next_y_count = y_count + 1'b1;
                end
            end
            F: begin
                // g=1 permanently until reset
                next_state = F;
                next_y_count = 2'd0;
            end
            G: begin
                // g=0 permanently until reset
                next_state = G;
                next_y_count = 2'd0;
            end
            default: begin
                // default to A
                next_state = A;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Outputs: Moore style from current state
    assign f = (state == B);
    assign g = (state == D || state == E || state == F);

endmodule