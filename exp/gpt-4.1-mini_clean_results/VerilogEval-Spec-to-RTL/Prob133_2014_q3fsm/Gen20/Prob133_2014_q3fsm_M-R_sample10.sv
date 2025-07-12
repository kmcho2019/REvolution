module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 4 states, using 2 bits
    localparam A  = 2'b00; // wait for s=1
    localparam B0 = 2'b01; // 1st sample cycle
    localparam B1 = 2'b10; // 2nd sample cycle
    localparam B2 = 2'b11; // 3rd sample cycle

    reg [1:0] state, next_state;
    reg [1:0] w_count, next_w_count; // count of w=1 in current 3-cycle window

    // Next state and next w_count logic (combinational)
    always @(*) begin
        next_state = state;
        next_w_count = w_count;
        z = 1'b0; // default output

        case(state)
            A: begin
                if (s)
                    next_state = B0;
                next_w_count = 2'd0;
                z = 1'b0;
            end

            B0: begin
                // first sample of w in window
                next_w_count = w_count + w;
                next_state = B1;
                z = 1'b0;
            end

            B1: begin
                // second sample of w in window
                next_w_count = w_count + w;
                next_state = B2;
                z = 1'b0;
            end

            B2: begin
                // third sample of w in window
                // Evaluate output on next cycle after B2
                // So output z is registered at B0 after accumulating 3 samples
                next_state = B0;

                // total count = w_count + w (all three samples)
                if (w_count + w == 2)
                    z = 1'b1;
                else
                    z = 1'b0;

                next_w_count = 2'd0; // reset count after output
            end

            default: begin
                next_state = A;
                next_w_count = 2'd0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential state, w_count, and output register update
    // Output z is registered here (matches combinational z assigned above)
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= z; // z assigned from combinational logic (to register it)
        end
    end

endmodule