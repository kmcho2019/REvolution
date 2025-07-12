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

    // Packed 4-bit register: [3:2]=w_accum (2 bits), [1:0]=cycle_cnt (2 bits)
    reg [3:0] cnt_accum, next_cnt_accum;

    wire [1:0] cycle_cnt = cnt_accum[1:0];
    wire [1:0] w_accum = cnt_accum[3:2];

    // Clock enable for counters update only in state B
    wire cnt_en = (state == B);

    // Combinational logic: next_state, next_cnt_accum, next_z
    reg next_z;

    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_cnt_accum = cnt_accum;
        next_z = 1'b0; // default 0, only 1 in specific case

        case (state)
            A: begin
                next_z = 1'b0;       // output 0 in state A
                next_cnt_accum = 4'd0; // clear counters in state A
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // On 3rd cycle of sampling, output z immediately
                    // z = 1 if (w_accum + w) == 2, else 0
                    // This is Mealy output: output depends on current w and accumulated count
                    next_z = ((w_accum + w) == 2);

                    // Reset counters after output
                    next_cnt_accum = 4'd0;
                end else begin
                    // Increment cycle counter and accumulate w
                    next_cnt_accum[1:0] = cycle_cnt + 2'd1;
                    next_cnt_accum[3:2] = w_accum + w;

                    next_z = 1'b0; // no output except at last cycle
                end
            end

            default: begin
                next_state = A;
                next_cnt_accum = 4'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic with clock enable for cnt_accum updates to reduce toggling power
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt_accum <= 4'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
            if (cnt_en)
                cnt_accum <= next_cnt_accum;
            else
                cnt_accum <= 4'd0;  // Hold zero outside B to reduce toggling
        end
    end

endmodule