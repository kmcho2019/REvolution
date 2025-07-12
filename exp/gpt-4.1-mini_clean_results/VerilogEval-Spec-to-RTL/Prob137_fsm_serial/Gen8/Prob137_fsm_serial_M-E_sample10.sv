module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);
    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam START   = 4'b0010;
    localparam RECEIVE = 4'b0100;
    localparam STOP    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold state
        case (state)
            IDLE: begin
                if (in == 1'b0)       // Detect start bit low
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // Confirm start bit still zero; otherwise back to IDLE
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP; // Wait for valid stop bit
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
            data_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    bit_count <= 3'b000;
                    data_reg <= 8'b0;
                end
                START: begin
                    bit_count <= 3'b000;
                    // no data shift here, just confirm start bit
                end
                RECEIVE: begin
                    // Shift in new bit LSB first by right-shifting data_reg
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    // Check stop bit, done pulses when stop bit valid
                    if (in == 1'b1)
                        done <= 1'b1;
                end
            endcase
        end
    end

endmodule