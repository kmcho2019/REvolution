module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // State encoding
    localparam IDLE    = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg waiting_for_stop;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            waiting_for_stop <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    waiting_for_stop <= 1'b0;
                    if (in == 1'b0)  // start bit detected
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    if (!waiting_for_stop) begin
                        if (bit_count < 3'd8) begin
                            // Shift in LSB first: shift right, insert new bit at MSB
                            shift_reg <= {in, shift_reg[7:1]};
                            bit_count <= bit_count + 1'b1;
                        end else begin
                            // Check stop bit
                            if (in == 1'b1) begin
                                // Byte received successfully; go back to IDLE
                                state <= IDLE;
                                bit_count <= 3'd0;
                                shift_reg <= 8'd0;
                            end else begin
                                // Stop bit invalid, wait for stop bit
                                waiting_for_stop <= 1'b1;
                            end
                        end
                    end else begin
                        // Waiting for stop bit to become 1
                        if (in == 1'b1) begin
                            // Stop bit detected, go back to IDLE
                            state <= IDLE;
                            bit_count <= 3'd0;
                            shift_reg <= 8'd0;
                            waiting_for_stop <= 1'b0;
                        end
                    end
                end
                default: begin
                    state <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    waiting_for_stop <= 1'b0;
                end
            endcase
        end
    end

    // done is high for one clock cycle on valid stop bit detection
    assign done = (state == RECEIVE) && (bit_count == 3'd8) && (in == 1'b1) && !waiting_for_stop;

endmodule