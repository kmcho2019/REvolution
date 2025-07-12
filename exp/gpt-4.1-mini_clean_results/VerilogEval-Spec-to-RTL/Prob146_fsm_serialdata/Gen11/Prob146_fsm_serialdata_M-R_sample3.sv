module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output wire       done
);

    // One-hot encoded states
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP_CHECK= 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // done is combinational: active only when in STOP_CHECK and stop bit is valid (in==1)
    assign done = (state == STOP_CHECK) && (in == 1'b1);

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
            end
            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential logic block: state, bit_count, shift_reg, out_byte updates
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;

            case (next_state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift data left, insert new bit at LSB for LSB-first reception
                    // shift_reg[7:1] <= previous bits; in at bit 0
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP_CHECK: begin
                    bit_count <= 3'd0;
                    // On done (valid stop bit), latch output byte
                    if (in == 1'b1)
                        out_byte <= shift_reg;
                end

                WAIT_STOP: begin
                    // Hold bit_count and shift_reg, waiting for line idle
                    bit_count <= 3'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule