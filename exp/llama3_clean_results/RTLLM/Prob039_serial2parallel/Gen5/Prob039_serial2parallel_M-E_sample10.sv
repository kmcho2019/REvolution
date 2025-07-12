module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg;
reg [2:0] state;

localparam IDLE = 3'b000;
localparam COLLECTING = 3'b001;

// Initialize the shift register, state, and output on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the shift register, state, and output
        shift_reg <= 8'b00000000;
        state <= IDLE;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (din_valid) begin
                    // Shift in the first bit and transition to COLLECTING state
                    shift_reg <= {7'b0, din_serial};
                    state <= COLLECTING;
                end
            end
            COLLECTING: begin
                if (din_valid) begin
                    // Shift in the next bit
                    shift_reg <= {shift_reg[6:0], din_serial};
                    if (&shift_reg[7:1]) begin
                        // All 8 bits collected, transfer to output and set valid signal
                        dout_parallel <= shift_reg;
                        dout_valid <= 1'b1;
                        state <= IDLE;
                    end
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule