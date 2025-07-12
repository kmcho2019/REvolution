module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            data_reg  <= 8'b0;
            bit_count <= 3'b0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done pulse low

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    data_reg  <= 8'b0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7)
                        state <= CHECK_STOP;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        done  <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule