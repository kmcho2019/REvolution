module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot state encoding for better performance and simpler decoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] data_reg;
    reg [3:0] bit_count; // 4 bits for simple increment and comparison

    // Next state logic and done generation combinational block
    // done is asserted when in CHECK_STOP state and in==1 (valid stop bit)
    assign done = (state == CHECK_STOP) && (in == 1'b1);

    always @(*) begin
        // Default next state remains current state
        next_state = state;

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 4'd7)
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

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            data_reg  <= 8'b0;
            bit_count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    data_reg  <= 8'b0;
                    bit_count <= 4'd0;
                end

                RECEIVE: begin
                    // Shift right, LSB first, insert new bit at MSB
                    data_reg  <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // Do not clear data_reg and bit_count here to avoid redundant toggling
                    // Hold values until state changes to IDLE or WAIT_STOP
                end

                WAIT_STOP: begin
                    // No register clearing here to reduce switching
                end

                default: begin
                    data_reg  <= 8'b0;
                    bit_count <= 4'd0;
                end
            endcase
        end
    end

endmodule