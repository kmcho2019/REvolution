module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding using parameters
    parameter IDLE       = 2'b00;
    parameter RECEIVE    = 2'b01;
    parameter CHECK_STOP = 2'b10;
    parameter WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            data_reg  <= 8'b0;
            bit_count <= 3'b0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default no done pulse each cycle

            case (state)
                IDLE: begin
                    data_reg  <= 8'b0;
                    bit_count <= 3'b0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    data_reg  <= {in, data_reg[7:1]};
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
                    data_reg  <= 8'b0;
                    bit_count <= 3'b0;
                end

                WAIT_STOP: begin
                    data_reg  <= 8'b0;
                    bit_count <= 3'b0;
                    if (in == 1'b1)
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule