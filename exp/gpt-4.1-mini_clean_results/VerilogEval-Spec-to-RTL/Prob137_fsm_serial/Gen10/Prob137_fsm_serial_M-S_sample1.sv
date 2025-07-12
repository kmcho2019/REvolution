module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low unless set below
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7)
                        state <= CHECK_STOP;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                end
            endcase
        end
    end

endmodule