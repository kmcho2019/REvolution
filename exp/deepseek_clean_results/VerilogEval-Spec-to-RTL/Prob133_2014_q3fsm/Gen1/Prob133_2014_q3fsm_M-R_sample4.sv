module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Sequential elements
    reg [1:0] cycle_count;
    reg [1:0] w_count;
    reg state_reg;

    // Combinational signals
    wire [1:0] next_cycle_count;
    wire [1:0] next_w_count;
    wire next_state;

    // Next state logic
    assign next_state = (reset) ? A :
                       (state == A) ? (s ? B : A) : B;

    // Cycle counter logic
    assign next_cycle_count = (reset || state == A) ? 2'b00 :
                             (cycle_count == 2'b10) ? 2'b00 :
                             cycle_count + 1'b1;

    // w counter logic
    assign next_w_count = (reset || state == A || cycle_count == 2'b10) ? 2'b00 :
                         (w) ? w_count + 1'b1 : w_count;

    // Output logic
    assign z = (state == B) && (cycle_count == 2'b10) && (w_count == 2'b10);

    // Sequential updates
    always @(posedge clk) begin
        state_reg <= next_state;
        cycle_count <= next_cycle_count;
        w_count <= next_w_count;
    end

    assign state = state_reg;

endmodule