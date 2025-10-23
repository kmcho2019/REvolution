module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    shift_enable <= 1'b0;
                    bit_count <= 3'd0;
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                    end
                end

                RECEIVE: begin
                    shift_enable <= 1'b1;
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                        shift_enable <= 1'b0;
                    end
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    shift_enable <= 1'b0;
                    if (in == 1'b1) begin
                        state <= IDLE;
                        bit_count <= 3'd0;
                    end
                end

                default: begin
                    state <= IDLE;
                    shift_enable <= 1'b0;
                end
            endcase

            // Shift register with shift enable to reduce combinational logic
            if (shift_enable) begin
                data_shift <= {in, data_shift[7:1]};
            end
        end
    end

endmodule