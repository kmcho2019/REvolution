module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE = 2'd0, DATA = 2'd1, WAIT_STOP = 2'd2;
    reg [1:0] state = IDLE;
    reg [2:0] bit_count = 3'd0;
    reg [7:0] shift_reg = 8'd0;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default
            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= DATA;
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end
                DATA: begin
                    shift_reg <= {shift_reg[6:0], in};
                    if (bit_count == 3'd7)
                        state <= WAIT_STOP;
                    bit_count <= bit_count + 1;
                end
                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        done  <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule