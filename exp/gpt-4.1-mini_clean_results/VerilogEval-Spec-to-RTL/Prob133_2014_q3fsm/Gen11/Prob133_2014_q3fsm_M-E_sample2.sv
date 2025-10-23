module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding: 2 bits to represent four states
    localparam [1:0]
        A  = 2'b00, // reset/wait state
        B0 = 2'b01, // first cycle of w observation
        B1 = 2'b10, // second cycle
        B2 = 2'b11; // third cycle

    reg [1:0] state, next_state;
    reg [1:0] w_count, next_w_count;
    reg next_z;

    always @(*) begin
        // Defaults
        next_state = state;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0; // output only in B states' sequences
                next_w_count = 2'd0;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                // accumulate w if 1
                next_w_count = w_count + w;
                next_state = B1;
                next_z = 1'b0;
            end

            B1: begin
                next_w_count = w_count + w;
                next_state = B2;
                next_z = 1'b0;
            end

            B2: begin
                // final accumulate for third cycle
                next_w_count = w_count + w;
                // output z=1 if exactly 2 ones counted
                next_z = (w_count + w) == 2;
                // After output, cycle back to B0 for next 3-cycle window
                next_state = B0;
            end

            default: begin
                next_state = A;
                next_w_count = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

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