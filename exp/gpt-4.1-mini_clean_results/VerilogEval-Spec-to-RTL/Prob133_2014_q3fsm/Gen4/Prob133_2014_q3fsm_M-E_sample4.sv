module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: use 2 bits for states
    localparam [1:0]
        A  = 2'b00,  // reset state, waiting for s=1
        C0 = 2'b01,  // first cycle of counting w in B
        C1 = 2'b10,  // second cycle
        C2 = 2'b11;  // third cycle

    reg [1:0] state, next_state;
    reg [1:0] w_count, next_w_count;
    reg next_z;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;           // no output in A
                next_w_count = 2'd0;    // clear count
                if (s)
                    next_state = C0;    // start counting w
                else
                    next_state = A;     // stay in A
            end
            C0: begin
                next_w_count = w_count + w;  // accumulate w
                next_state = C1;             // move to next cycle
                next_z = 1'b0;               // no output yet
            end
            C1: begin
                next_w_count = w_count + w;  // accumulate w
                next_state = C2;             // move to next cycle
                next_z = 1'b0;               // no output yet
            end
            C2: begin
                // accumulate w and output z next cycle if count == 2
                // Here, next_w_count holds sum of previous two cycles,
                // add current w to get total
                if ((w_count + w) == 2)
                    next_z = 1'b1;
                else
                    next_z = 1'b0;

                next_w_count = 2'd0;        // reset count for next window
                next_state = C0;            // restart counting next window
            end
        endcase
    end

    // Sequential block: update state, w_count, and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= next_z;
        end
    end

endmodule