module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire bit_count_done = (bit_count == 3'd7);

    // Next state and output logic
    wire next_idle = (state == IDLE) & in |
                    (state == STOP) & in |
                    (state == ERROR) & in;

    wire next_receive = (state == IDLE) & ~in |
                       (state == RECEIVE) & ~bit_count_done;

    wire next_stop = (state == RECEIVE) & bit_count_done;

    wire next_error = (state == STOP) & ~in;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            case (1'b1)  // synthesis parallel_case
                next_idle: begin
                    state <= IDLE;
                    bit_count <= 0;
                end
                next_receive: begin
                    state <= RECEIVE;
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                next_stop: begin
                    state <= STOP;
                end
                next_error: begin
                    state <= ERROR;
                end
            endcase

            // Capture output when valid stop bit
            if ((state == STOP) & in) begin
                out_byte <= shift_reg;
            end
        end
    end

    // Done pulses when valid stop bit detected
    assign done = (state == STOP) & in;

endmodule