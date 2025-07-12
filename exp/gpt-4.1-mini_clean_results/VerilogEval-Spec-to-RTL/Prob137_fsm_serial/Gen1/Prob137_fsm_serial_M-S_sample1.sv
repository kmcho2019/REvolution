module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    localparam IDLE = 2'd0;
    localparam DATA = 2'd1;
    localparam STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end
                DATA: begin
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? DATA : IDLE;
            DATA:    next_state = (bit_count == 3'd7) ? STOP : DATA;
            STOP:    next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule