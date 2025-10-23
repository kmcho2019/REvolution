module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot encoded states
    reg SEARCH0, SEARCH1, SEARCH2, SEARCH3, SHIFT, COUNT, DONE;

    // Next state signals
    reg n_SEARCH0, n_SEARCH1, n_SEARCH2, n_SEARCH3, n_SHIFT, n_COUNT, n_DONE;

    // 3-bit counter for shift cycles (counts 0..3)
    reg [1:0] shift_count;
    reg [1:0] n_shift_count;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            SEARCH0 <= 1'b1;
            SEARCH1 <= 1'b0;
            SEARCH2 <= 1'b0;
            SEARCH3 <= 1'b0;
            SHIFT   <= 1'b0;
            COUNT   <= 1'b0;
            DONE    <= 1'b0;
            shift_count <= 2'd0;
        end else begin
            SEARCH0 <= n_SEARCH0;
            SEARCH1 <= n_SEARCH1;
            SEARCH2 <= n_SEARCH2;
            SEARCH3 <= n_SEARCH3;
            SHIFT   <= n_SHIFT;
            COUNT   <= n_COUNT;
            DONE    <= n_DONE;
            shift_count <= n_shift_count;
        end
    end

    // Next state logic combinational
    always @(*) begin
        // Defaults: no next states
        n_SEARCH0 = 1'b0;
        n_SEARCH1 = 1'b0;
        n_SEARCH2 = 1'b0;
        n_SEARCH3 = 1'b0;
        n_SHIFT   = 1'b0;
        n_COUNT   = 1'b0;
        n_DONE    = 1'b0;

        n_shift_count = shift_count;

        if (SEARCH0) begin
            if (data)
                n_SEARCH1 = 1'b1;
            else
                n_SEARCH0 = 1'b1;
            n_shift_count = 2'd0;
        end else if (SEARCH1) begin
            if (data)
                n_SEARCH2 = 1'b1;
            else
                n_SEARCH0 = 1'b1;
            n_shift_count = 2'd0;
        end else if (SEARCH2) begin
            if (~data)
                n_SEARCH3 = 1'b1;
            else
                n_SEARCH2 = 1'b1; // stay here, still matched '11' prefix
            n_shift_count = 2'd0;
        end else if (SEARCH3) begin
            if (data)
                n_SHIFT = 1'b1; // full pattern detected
            else
                n_SEARCH0 = 1'b1;
            n_shift_count = 2'd0;
        end else if (SHIFT) begin
            // increment shift_count until 3, then move to COUNT
            if (shift_count == 2'd3) begin
                n_COUNT = 1'b1;
                n_shift_count = 2'd0;
            end else begin
                n_SHIFT = 1'b1;
                n_shift_count = shift_count + 2'd1;
            end
        end else if (COUNT) begin
            if (done_counting)
                n_DONE = 1'b1;
            else
                n_COUNT = 1'b1;
            n_shift_count = 2'd0;
        end else if (DONE) begin
            if (ack)
                n_SEARCH0 = 1'b1;
            else
                n_DONE = 1'b1;
            n_shift_count = 2'd0;
        end else begin
            // Fallback to SEARCH0 for safety
            n_SEARCH0 = 1'b1;
            n_shift_count = 2'd0;
        end
    end

    // Output signals: combinational from one-hot state registers
    assign shift_ena = SHIFT;
    assign counting  = COUNT;
    assign done      = DONE;

endmodule