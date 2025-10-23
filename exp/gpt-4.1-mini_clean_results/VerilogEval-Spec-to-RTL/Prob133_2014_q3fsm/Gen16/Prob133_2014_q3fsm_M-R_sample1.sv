module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0, B = 1'b1;
    reg state;

    reg [1:0] cycle_cnt;  // counts 0,1,2 for 3 cycles
    reg [1:0] w_count;    // counts number of times w=1 in 3 cycles

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: if (s) state <= B;
                B: ; // remain in B
            endcase
        end
    end

    // Counters update (only in state B)
    always @(posedge clk) begin
        if (reset || state == A) begin
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
        end else if (state == B) begin
            cycle_cnt <= (cycle_cnt == 2) ? 2'd0 : cycle_cnt + 1;
            if (cycle_cnt != 2)
                w_count <= w_count + w;
            else
                w_count <= w;  // start counting next group with current w
        end
    end

    // Output z generation
    // z asserted one cycle after counting exactly two w=1 in the last 3 cycles
    reg z_next;
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            z <= z_next;
            if (state == B && cycle_cnt == 2) begin
                // At cycle_cnt==2, we just completed counting 3 cycles: w_count + current w counted previously in logic
                z_next <= (w_count == 2);
            end else begin
                z_next <= 1'b0;
            end
        end
    end

endmodule