module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot encoded states
    localparam IDLE       = 4'b0001;
    localparam READ_BITS  = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? READ_BITS : IDLE;
            READ_BITS:
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : READ_BITS;
            CHECK_STOP:
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            RECOVER:
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            default:
                next_state = IDLE;
        endcase
    end

    // Bit counter logic
    always @(posedge clk) begin
        if (reset || state != READ_BITS)
            bit_cnt <= 3'd0;
        else if (state == READ_BITS)
            bit_cnt <= bit_cnt + 1'b1;
    end

    // Shift register logic: shift in LSB first by shifting left, new bit at LSB
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == READ_BITS)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output and done signal logic
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    out_byte <= shift_reg;
                    done <= 1'b1; // pulse done for one cycle after stop bit detected
                end
            end
        end
    end

endmodule