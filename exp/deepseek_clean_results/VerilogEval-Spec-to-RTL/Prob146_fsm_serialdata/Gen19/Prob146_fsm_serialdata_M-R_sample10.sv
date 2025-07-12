module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_pulse;

    // Next state and output logic (combinational)
    wire next_idle    = (state == IDLE)    ? ~in : 
                       (state == STOP)    ? in : 
                       1'b0;
    wire next_receive = (state == IDLE)    ? ~in : 
                       (state == RECEIVE) ? (bit_count != 3'b111) : 
                       1'b0;
    wire next_stop    = (state == RECEIVE) ? (bit_count == 3'b111) : 
                       (state == STOP)     ? ~in : 
                       1'b0;

    // State transition (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            case (1'b1)  // synthesis parallel_case
                next_idle: begin
                    state <= IDLE;
                    bit_count <= 3'b0;
                    if (state == STOP && in) begin
                        out_byte <= shift_reg;
                    end
                end
                next_receive: begin
                    state <= RECEIVE;
                    shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                    bit_count <= bit_count + 1;
                end
                next_stop: begin
                    state <= STOP;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Generate done pulse when valid stop bit is detected
    always @(posedge clk) begin
        if (reset) begin
            done_pulse <= 1'b0;
        end else begin
            done_pulse <= (state == STOP) && in;
        end
    end

    assign done = done_pulse;

endmodule