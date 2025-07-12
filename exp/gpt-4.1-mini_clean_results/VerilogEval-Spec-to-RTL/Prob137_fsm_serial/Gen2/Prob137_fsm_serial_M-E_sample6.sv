module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);
    // State encoding
    localparam IDLE      = 2'b00;
    localparam DATA      = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] bit_count; // to count 8 data bits (0 to 7)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                IDLE: begin
                    bit_count <= 4'd0;
                    if (in == 1'b0) begin
                        // Start bit detected
                        state <= DATA;
                    end else begin
                        state <= IDLE;
                    end
                end

                DATA: begin
                    // Sample 8 data bits, least significant bit first
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 4'd7) begin
                        state <= STOP; // after last data bit, check stop bit next
                    end else begin
                        state <= DATA;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        done <= 1'b1; // pulse done one cycle
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    // Wait until line returns to idle state (1)
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                default: begin
                    state <= IDLE;
                    bit_count <= 4'd0;
                end
            endcase
        end
    end

endmodule