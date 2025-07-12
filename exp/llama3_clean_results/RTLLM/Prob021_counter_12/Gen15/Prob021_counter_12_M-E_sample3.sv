module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] state, next_state;

// One-hot encoding for states
always_comb begin
    case (state)
        4'b0001: next_state = (valid_count && state != 4'b1000) ? 4'b0010 : (rst_n ? state : 4'b0001);
        4'b0010: next_state = (valid_count && state != 4'b1000) ? 4'b0100 : (rst_n ? state : 4'b0001);
        4'b0100: next_state = (valid_count && state != 4'b1000) ? 4'b1000 : (rst_n ? state : 4'b0001);
        4'b1000: next_state = (valid_count) ? 4'b0001 : (rst_n ? state : 4'b0001);
        default: next_state = (valid_count) ? 4'b0001 : (rst_n ? 4'b0001 : 4'b0001);
    endcase
end

// Sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 4'b0001; // Reset to state 0
    end else begin
        state <= next_state;
    end
end

// Output logic
always_comb begin
    case (state)
        4'b0001: out = 4'b0000;
        4'b0010: out = 4'b0001;
        4'b0100: out = 4'b0010;
        4'b1000: out = 4'b0011;
        default: out = 4'b0000;
    endcase
end

endmodule