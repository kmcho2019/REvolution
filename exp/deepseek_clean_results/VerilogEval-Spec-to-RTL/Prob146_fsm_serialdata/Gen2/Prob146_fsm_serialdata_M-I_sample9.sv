module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_pulse;

    // Registered next state for better timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done_pulse <= 1'b0;
        end else begin
            state <= next_state;
            done_pulse <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    if (bit_count < 3'b111) begin
                        shift_reg <= {shift_reg[6:0], in};  // Left shift (MSB first)
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done_pulse <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP:   next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

    // Generate single-cycle done pulse
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= done_pulse;
        end
    end

endmodule