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

    // Next state and output logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state = RECEIVE;
                end else begin
                    state = IDLE;
                end
            end
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    state = STOP;
                end else begin
                    state = RECEIVE;
                end
            end
            STOP: begin
                state = IDLE;
            end
            default: state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done_pulse <= 0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    done_pulse <= 0;
                    if (!in) begin
                        shift_reg <= 0;
                    end
                end
                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in};  // Left shift
                    bit_count <= bit_count + 1;
                    done_pulse <= 0;
                end
                STOP: begin
                    out_byte <= shift_reg;
                    done_pulse <= in;  // Only pulse if stop bit valid
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Done is a one-cycle pulse
    assign done = done_pulse;

endmodule