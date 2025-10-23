module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse after reset
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1 pulse after pattern detected
        E = 3'd4, // g=1 hold, monitor y for 2 cycles
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    reg [2:0] state;
    reg [2:0] x_shift;   // shift register for last 3 x inputs
    reg [1:0] y_count;   // counter for y monitoring cycles in E

    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous active low reset
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'd0;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            case (state)
                A: begin
                    // Stay in A while resetn=0 (already ensured by if(!resetn))
                    // When resetn=1, move to B next clock
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= B;
                end

                B: begin
                    // One cycle f=1 pulse immediately after leaving reset
                    f       <= 1'b1;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= C;
                end

                C: begin
                    // Monitor x for pattern 1,0,1 in consecutive clock cycles
                    // Shift in current x input first
                    x_shift <= {x_shift[1:0], x};
                    f       <= 1'b0;
                    g       <= 1'b0;
                    y_count <= 2'd0;
                    // After shifting, check if x_shift is 3'b101 (means last 3 x inputs = 1,0,1)
                    // Must check after updating x_shift, so use next state logic here
                    if ({x_shift[1:0], x} == 3'b101) 
                        state <= D;
                    else
                        state <= C;
                end

                D: begin
                    // g=1 pulse for 1 clock after detecting pattern
                    f       <= 1'b0;
                    g       <= 1'b1;
                    x_shift <= 3'b000;  // Clear x_shift, no longer monitoring x pattern
                    y_count <= 2'd0;
                    state   <= E;
                end

                E: begin
                    // Hold g=1, monitor y for up to 2 clock cycles
                    f <= 1'b0;
                    g <= 1'b1;
                    // No more x monitoring here
                    // y_count counts how many cycles have passed monitoring y
                    if (y == 1'b1) begin
                        // y=1 detected within 2 cycles: hold g=1 permanently
                        y_count <= 2'd0;
                        state <= F;
                    end else if (y_count == 2'd1) begin
                        // Two cycles elapsed without y=1, move to g=0 permanent
                        y_count <= 2'd0;
                        state <= G;
                    end else begin
                        // Increment count and stay in E
                        y_count <= y_count + 1'b1;
                        state <= E;
                    end
                    // x_shift unused here, keep as zero to avoid confusion
                    x_shift <= 3'b000;
                end

                F: begin
                    // g=1 permanent hold until reset
                    f       <= 1'b0;
                    g       <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= F;
                end

                G: begin
                    // g=0 permanent hold until reset
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= G;
                end

                default: begin
                    // Should never happen; reset to A
                    state   <= A;
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

endmodule