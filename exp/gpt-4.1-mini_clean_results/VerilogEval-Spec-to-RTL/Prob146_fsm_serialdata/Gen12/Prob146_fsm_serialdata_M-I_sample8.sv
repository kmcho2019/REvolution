module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam READ_BITS  = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] data_shift;

    reg done_reg;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable only in READ_BITS
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == READ_BITS)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Data shift register enabled only during READ_BITS
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == READ_BITS)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Done pulse generation register
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default low

            // Assert done only for one cycle at CHECK_STOP with valid stop bit
            if (state == CHECK_STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= data_shift;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)       // start bit detected
                    next_state = READ_BITS;
                else
                    next_state = IDLE;
            end

            READ_BITS: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = READ_BITS;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // valid stop bit
                else
                    next_state = RECOVER;   // wait for idle line
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule