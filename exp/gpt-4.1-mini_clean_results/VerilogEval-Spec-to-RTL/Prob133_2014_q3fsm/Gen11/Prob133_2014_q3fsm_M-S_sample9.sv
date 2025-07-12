module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0, B = 1'b1;
    reg state, next_state;

    reg [2:0] w_shift;  // shift register to hold 3 cycles of w
    reg [1:0] count_ones; // count of ones in w_shift
    reg [1:0] cycle_count; // counts 0,1,2 cycles in B

    wire [1:0] ones_count;
    integer i;

    // Combinational function: count ones in 3-bit w_shift
    function [1:0] count_ones_in_shift;
        input [2:0] bits;
        integer j;
        begin
            count_ones_in_shift = 0;
            for (j=0; j<3; j=j+1)
                count_ones_in_shift = count_ones_in_shift + bits[j];
        end
    endfunction

    always @(*) begin
        next_state = state;
        z = 1'b0; // default output is 0

        case(state)
            A: begin
                if (s)
                    next_state = B;
            end

            B: begin
                if (cycle_count == 2'd3) begin
                    // after 3 cycles, output based on count_ones
                    if (count_ones == 2)
                        z = 1'b1;
                end
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b000;
            cycle_count <= 2'd0;
            count_ones <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // reset counters in A
                w_shift <= 3'b000;
                cycle_count <= 2'd0;
                count_ones <= 2'd0;
                z <= 1'b0;
            end else if (state == B) begin
                if (cycle_count < 2'd3) begin
                    // shift in w
                    w_shift <= {w_shift[1:0], w};
                    cycle_count <= cycle_count + 1'b1;
                    z <= 1'b0; // no output until count done
                end else begin
                    // after 3 cycles, count ones and output z
                    count_ones <= count_ones_in_shift(w_shift);
                    z <= (count_ones_in_shift(w_shift) == 2);
                    cycle_count <= 1'b1; // restart counting with current w
                    w_shift <= {w_shift[1:0], w};
                end
            end
        end
    end

endmodule