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

    reg state;
    reg [1:0] cycle_cnt;
    reg [1:0] w_count;

    // Next-state signals
    wire next_state;
    wire [1:0] next_cycle_cnt;
    wire [1:0] next_w_count;
    wire z_next;

    // Next state logic
    assign next_state = (state == A) ? (s ? B : A) : B;

    // Next cycle count logic
    assign next_cycle_cnt = (state == A) ? 2'b00 :
                           (cycle_cnt == 2) ? 2'b00 : cycle_cnt + 1;

    // Next w_count logic
    assign next_w_count = (state == A) ? 2'b00 :
                          (cycle_cnt == 2) ? 2'b00 : w_count + w;

    // Combinational output logic (Mealy style)
    assign z_next = (state == B && cycle_cnt == 2 && (w_count + w) == 2) ? 1'b1 : 1'b0;

    // Sequential logic: state, counters, output update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

endmodule