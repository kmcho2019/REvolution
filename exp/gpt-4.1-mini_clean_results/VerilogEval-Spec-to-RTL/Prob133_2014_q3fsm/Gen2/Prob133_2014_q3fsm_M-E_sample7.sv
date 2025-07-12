module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding using localparam for compatibility
    localparam [1:0]
        A  = 2'b00, // Waiting for s=1
        C0 = 2'b01, // Sample 1 of w
        C1 = 2'b10, // Sample 2 of w
        C2 = 2'b11; // Sample 3 of w and evaluate output

    reg [1:0] state, next_state;
    reg [1:0] w_count;    // Counts how many w=1 in current 3-cycle window
    reg       z_next;

    // Sequential logic: state, w_count, z update
    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            w_count <= 2'd0;
            z       <= 1'b0;
        end else begin
            state   <= next_state;
            z       <= z_next;

            if (state == A) begin
                w_count <= 2'd0;
            end else begin
                // Accumulate w only in C0, C1, C2 states
                if (state != C2)
                    w_count <= w_count + w;
                else
                    w_count <= 2'd0; // reset count after evaluation in C2
            end
        end
    end

    // Combinational logic: next state and z_next
    always @(*) begin
        next_state = state;
        z_next = 1'b0;

        case (state)
            A: begin
                if (s)
                    next_state = C0;
            end

            C0: begin
                next_state = C1;
            end

            C1: begin
                next_state = C2;
            end

            C2: begin
                // Evaluate if total w_count + current w == 2 (exactly two 1s)
                // w_count holds count of first two w's, current w is the 3rd sample
                if ((w_count + w) == 2)
                    z_next = 1'b1;
                else
                    z_next = 1'b0;

                next_state = C0;
            end

            default: begin
                next_state = A;
                z_next = 1'b0;
            end
        endcase
    end

endmodule