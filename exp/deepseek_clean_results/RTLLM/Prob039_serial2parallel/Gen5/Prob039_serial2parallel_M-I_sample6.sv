module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;    // Combined shift/parallel register
    reg [7:0] state;        // One-hot state machine
    wire shift_en = din_valid & ~dout_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            state <= 8'b00000001;  // Initial state
            dout_valid <= 1'b0;
        end else begin
            // Shift register with clock gating
            if (shift_en) begin
                shift_reg <= {shift_reg[6:0], din_serial};
            end

            // State transitions
            if (shift_en) begin
                state <= {state[6:0], state[7]};
            end

            // Output valid generation
            dout_valid <= shift_en & state[7];
        end
    end

    // Parallel output is always the current register value
    assign dout_parallel = shift_reg;

endmodule