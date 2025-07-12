module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding: 3 states
    localparam A  = 2'd0; // wait for s=1
    localparam B0 = 2'd1; // sample w #1
    localparam B1 = 2'd2; // sample w #2
    localparam B2 = 2'd3; // sample w #3 and then output decision

    reg [1:0] state, next_state;
    reg [1:0] w_count, next_w_count; // counts how many w=1 in current 3-cycle window
    reg next_z;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_w_count = 2'b00;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: begin
                // first w sample
                next_w_count = w_count + w;
                next_state = B1;
                next_z = 1'b0;
            end
            B1: begin
                // second w sample
                next_w_count = w_count + w;
                next_state = B2;
                next_z = 1'b0;
            end
            B2: begin
                // third w sample, decide output next cycle (in A or B0)
                next_w_count = 2'b00; // reset after this cycle
                next_state = B0;
                // output z = 1 if exactly 2 w=1 among 3 cycles (current w + previous count)
                // w_count currently counts 2 cycles, add current w for third cycle
                next_z = ((w_count + w) == 2);
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= next_z;
        end
    end

endmodule