module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // 3-bit shift register to store last 3 w values
    reg [2:0] w_history;
    wire shift_reg_full = &w_history; // All bits are valid after 3 shifts

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Popcount of w_history (count number of 1s)
    wire [1:0] popcount = w_history[0] + w_history[1] + w_history[2];

    // Output logic - active when in state B, shift register is full, and exactly two 1s
    assign z = (state == B) && shift_reg_full && (popcount == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update shift register
                w_history <= {w_history[1:0], w};
            end else begin
                // Reset shift register when in state A
                w_history <= 3'b000;
            end
        end
    end

endmodule