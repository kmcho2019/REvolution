module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;
    localparam ERROR  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // Default done to 0 unless in STOP state with valid stop bit

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin  // Start bit detected
                        next_state <= RECEIVE;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    if (bit_count == 3'd7) begin
                        next_state <= STOP;
                        bit_count <= 0;
                    end else begin
                        bit_count <= bit_count + 1;
                        next_state <= RECEIVE;
                    end
                end

                STOP: begin
                    if (in == 1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        next_state <= IDLE;
                    end else begin  // Missing stop bit
                        next_state <= ERROR;
                    end
                end

                ERROR: begin
                    if (in == 1) begin  // Found stop bit
                        next_state <= IDLE;
                    end else begin
                        next_state <= ERROR;
                    end
                end

                default: next_state <= IDLE;
            endcase
        end
    end

endmodule