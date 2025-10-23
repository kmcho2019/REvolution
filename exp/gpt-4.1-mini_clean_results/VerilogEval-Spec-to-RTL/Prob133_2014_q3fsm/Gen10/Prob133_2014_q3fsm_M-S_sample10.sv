module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // States: A = waiting for s=1, B0,B1,B2 = counting w samples
    localparam A  = 2'd0;
    localparam B0 = 2'd1;
    localparam B1 = 2'd2;
    localparam B2 = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] w_accum, next_w_accum;
    reg       z_next;

    always @(*) begin
        // Defaults
        next_state = state;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                z_next = 1'b0;
                next_w_accum = 2'd0;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: begin
                // On first cycle, accumulate w and go to B1
                next_w_accum = w_accum + w;
                next_state = B1;
                z_next = 1'b0;
            end
            B1: begin
                // On second cycle, accumulate w and go to B2
                next_w_accum = w_accum + w;
                next_state = B2;
                z_next = 1'b0;
            end
            B2: begin
                // On third cycle, accumulate w and evaluate output
                next_w_accum = 2'd0;
                next_state = B0;
                // Output 1 if exactly two w=1 in these three cycles
                // Since w_accum has count for first two cycles, add current w and check == 2
                if ((w_accum + w) == 2)
                    z_next = 1'b1;
                else
                    z_next = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_accum <= next_w_accum;
            z <= z_next;
        end
    end

endmodule