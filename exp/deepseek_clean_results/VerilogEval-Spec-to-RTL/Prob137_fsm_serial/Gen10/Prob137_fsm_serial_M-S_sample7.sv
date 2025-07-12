module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary state encoding
    localparam IDLE = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP = 2'b10;
    localparam WAIT = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (!in) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                    end
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    done <= in;
                    if (in) begin
                        state <= IDLE;
                    end else begin
                        state <= WAIT;
                    end
                end
                WAIT: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule