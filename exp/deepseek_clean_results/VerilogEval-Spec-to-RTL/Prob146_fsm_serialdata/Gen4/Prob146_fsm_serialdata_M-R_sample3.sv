module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Binary encoded states
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam WAIT_STOP = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                    end
                end

                RECEIVE: begin
                    if (bit_count == 3'd7) begin
                        state <= WAIT_STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                WAIT_STOP: begin
                    if (in) begin
                        state <= IDLE;
                        done <= 1;
                        out_byte <= shift_reg;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Shift register update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
        end else if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

endmodule