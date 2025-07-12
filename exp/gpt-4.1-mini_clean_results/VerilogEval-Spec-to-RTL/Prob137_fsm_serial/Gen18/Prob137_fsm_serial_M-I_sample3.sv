module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE  = 2'd0,
               DATA  = 2'd1,
               STOP  = 2'd2,
               ERROR = 2'd3;

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
            done <= 1'b0;  // Default done low

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)
                        state <= DATA;
                    else
                        state <= IDLE;
                end

                DATA: begin
                    // Shift in LSB first: new bit into LSB, shift left
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd7)
                        state <= STOP;
                    else
                        state <= DATA;
                end

                STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b1) begin
                        done  <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b1)
                        state <= IDLE;
                    else
                        state <= ERROR;
                end

                default: begin
                    state     <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule