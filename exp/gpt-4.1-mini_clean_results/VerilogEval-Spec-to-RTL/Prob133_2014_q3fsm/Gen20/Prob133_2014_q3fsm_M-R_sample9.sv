module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    // One-hot state encoding
    reg state_A, state_B;
    wire next_state_A, next_state_B;

    // Counters for cycle count and w accumulator in state B
    reg [1:0] cycle_cnt;
    reg [1:0] w_accum;

    // Combinational signals for next values
    reg [1:0] cycle_cnt_next;
    reg [1:0] w_accum_next;
    reg z_next_comb;

    // State transition logic (combinational)
    assign next_state_A = reset ? 1'b1 : (state_A & ~s);
    assign next_state_B = reset ? 1'b0 : (state_A & s) | (state_B);

    // Sequential logic for state registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Counters update logic in state B only
    always @(posedge clk) begin
        if (reset) begin
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
        end else if (state_B) begin
            if (cycle_cnt == 2) begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end else begin
                cycle_cnt <= cycle_cnt + 2'd1;
                w_accum <= w_accum + w;
            end
        end else begin
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
        end
    end

    // Combinational logic for z generation
    always @(*) begin
        // Default output
        z_next_comb = 1'b0;

        if (state_B && (cycle_cnt == 2)) begin
            // On the third cycle, check if exactly two w=1 were observed (including current w)
            z_next_comb = ((w_accum + w) == 2);
        end
    end

    // Registered output z updated on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= z_next_comb;
        end
    end

endmodule