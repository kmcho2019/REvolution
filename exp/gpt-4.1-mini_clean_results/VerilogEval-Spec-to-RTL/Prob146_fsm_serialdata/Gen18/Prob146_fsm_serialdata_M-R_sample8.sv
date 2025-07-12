module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot state encoding
    localparam IDLE          = 3'b001;
    localparam RECEIVING     = 3'b010;
    localparam STOP_BIT_CHECK= 3'b100;

    reg [2:0] state, next_state;

    reg [2:0] bit_count;      // count 0 to 7
    reg [7:0] data_shift;

    // Next state logic (combinational)
    always @(*) begin
        done = 1'b0; // default no done pulse

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVING; // start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT_CHECK;
                else
                    next_state = RECEIVING;
            end

            STOP_BIT_CHECK: begin
                if (in == 1'b1) begin
                    done = 1'b1;    // stop bit valid, done pulse
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT_CHECK; // wait for stop bit to become 1
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Data shift register and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVING: begin
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1;
                end

                STOP_BIT_CHECK: begin
                    // no change to bit_count or data_shift during stop bit check
                end

                default: begin
                    // no changes
                end
            endcase
        end
    end

    // Output latch for data byte (register done pulse)
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            // done is combinationally generated in always @(*) block, but we register done output here
            // latch out_byte when done pulse occurs
            if (done)
                out_byte <= data_shift;
            else
                out_byte <= out_byte; // retain value when done is low

            // done pulse is registered here
            done <= done;
        end
    end

endmodule