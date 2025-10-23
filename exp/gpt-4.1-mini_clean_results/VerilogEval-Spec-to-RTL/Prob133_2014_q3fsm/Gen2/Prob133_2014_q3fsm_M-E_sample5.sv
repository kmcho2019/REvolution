module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_count;    // counts 0,1,2 for 3 cycles
    reg [2:0] w_shift;        // shift register holding last 3 w inputs
    reg z_pending;            // holds whether z should be asserted next cycle

    // Combinational next_state logic
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Count number of bits set in w_shift
    function [1:0] popcount3;
        input [2:0] bits;
        begin
            popcount3 = bits[0] + bits[1] + bits[2];
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_shift <= 3'd0;
            z <= 1'b0;
            z_pending <= 1'b0;
        end else begin
            state <= next_state;

            // Default output zero
            z <= z_pending;
            z_pending <= 1'b0;

            case (state)
                A: begin
                    // Clear counters on A
                    cycle_count <= 2'd0;
                    w_shift <= 3'd0;
                end

                B: begin
                    // Shift in new w bit
                    w_shift <= {w_shift[1:0], w};

                    if (cycle_count == 2) begin
                        // After 3 samples, check how many ones in w_shift + current w
                        // Actually w_shift includes last two w's + previous w from cycle 1 and 2,
                        // but we just shifted in current w, so w_shift has last 3 w's.
                        // Popcount over w_shift gives the count.

                        if (popcount3(w_shift) == 2)
                            z_pending <= 1'b1;
                        cycle_count <= 2'd0;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule