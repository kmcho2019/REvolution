module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output wire       done
);

    // One-hot state encoding
    localparam IDLE_BIT      = 4'b0001;
    localparam RECEIVE_BIT   = 4'b0010;
    localparam STOP_BIT      = 4'b0100;
    localparam WAIT_STOP_BIT = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    wire receiving = state[1]; // RECEIVE state

    // Synchronous state update with reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE_BIT;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        next_state = IDLE_BIT; // default

        case (state)
            IDLE_BIT: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE_BIT;
                else
                    next_state = IDLE_BIT;
            end

            RECEIVE_BIT: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT; // after 8 bits
                else
                    next_state = RECEIVE_BIT;
            end

            STOP_BIT: begin
                if (in == 1'b1)
                    next_state = IDLE_BIT;     // valid stop bit
                else
                    next_state = WAIT_STOP_BIT;// invalid stop bit
            end

            WAIT_STOP_BIT: begin
                if (in == 1'b1)
                    next_state = IDLE_BIT;     // wait for idle line
                else
                    next_state = WAIT_STOP_BIT;
            end

            default: next_state = IDLE_BIT;
        endcase
    end

    // Bit counter and shift register update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            if (state == IDLE_BIT) begin
                if (in == 1'b0) begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
            end else if (state == RECEIVE_BIT) begin
                bit_count <= bit_count + 3'd1;
                // Shift in LSB first; in is new LSB
                data_shift <= {in, data_shift[7:1]};
            end else if (state == STOP_BIT || state == WAIT_STOP_BIT) begin
                bit_count <= 3'd0; // reset count at end or error wait
            end
        end
    end

    // Output latch when valid stop bit received
    always @(posedge clk) begin
        if (reset)
            out_byte <= 8'd0;
        else if (state == STOP_BIT && in == 1'b1)
            out_byte <= data_shift;
    end

    // done signal combinational: one cycle pulse on valid stop bit detection
    assign done = (state == STOP_BIT) && (in == 1'b1);

endmodule