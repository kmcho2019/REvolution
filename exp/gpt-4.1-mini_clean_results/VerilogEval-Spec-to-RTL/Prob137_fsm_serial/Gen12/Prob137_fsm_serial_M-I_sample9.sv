module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Data register and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            data_reg  <= 8'b0;
            bit_count <= 3'b0;
        end else begin
            case(state)
                IDLE: begin
                    data_reg  <= 8'b0;
                    bit_count <= 3'b0;
                end
                RECEIVE: begin
                    // Shift right by one, insert new bit at MSB (LSB-first)
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                CHECK_STOP, WAIT_STOP: begin
                    // Hold data_reg and bit_count; clear on next IDLE
                    data_reg  <= data_reg;
                    bit_count <= bit_count;
                end
                default: begin
                    data_reg  <= 8'b0;
                    bit_count <= 3'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Done generation: pulse high for one cycle when stop bit valid detected
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else if (state == CHECK_STOP && in == 1'b1)
            done <= 1'b1;
        else
            done <= 1'b0;
    end

endmodule