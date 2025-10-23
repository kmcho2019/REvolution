module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output reg         done
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // Detect start bit
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Correct stop bit
                else
                    next_state = WAIT_STOP; // Wait until stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit count update, enabled only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= 3'd0;
    end

    // Data shift register, shift-left, new bit at LSB (LSB-first)
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE) begin
            if (in == 1'b0)
                data_shift <= 8'd0; // Clear on start bit detected
        end else if (state == RECEIVE) begin
            data_shift <= {in, data_shift[7:1]};
        end
        // Hold data_shift in STOP and WAIT_STOP states
    end

    // Output and done signal generation
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default no done

            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;  // Assert done for one cycle on correct stop bit
            end
        end
    end

endmodule