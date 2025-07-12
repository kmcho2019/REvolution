module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg [7:0] byte_out;

    // Next state logic (combinational)
    wire next_idle    = (state == IDLE)    & ~in |
                        (state == STOP)    & in;
    wire next_receive = (state == IDLE)    & ~in |
                        (state == RECEIVE) & (bit_count != 3'b111);
    wire next_stop    = (state == RECEIVE) & (bit_count == 3'b111);

    // State transition (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (1'b1)
                next_idle:    state <= IDLE;
                next_receive: state <= RECEIVE;
                next_stop:    state <= STOP;
                default:      state <= state;
            endcase
        end
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset | (state == IDLE)) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end
    end

    // Shift register (LSB first)
    always @(posedge clk) begin
        if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]};
        end
    end

    // Output byte capture
    always @(posedge clk) begin
        if (state == STOP && in) begin
            byte_out <= shift_reg;
        end
    end

    // Output assignments
    assign out_byte = byte_out;
    assign done = (state == STOP) & in;

endmodule