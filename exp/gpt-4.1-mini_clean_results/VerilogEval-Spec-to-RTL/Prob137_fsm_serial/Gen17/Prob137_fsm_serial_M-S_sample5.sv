module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam [1:0]
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default no pulse
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd7)
                        state <= CHECK_STOP;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        done  <= 1'b1;
                        state <= IDLE;
                    end else
                        state <= WAIT_STOP;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                end

            endcase
        end
    end

endmodule