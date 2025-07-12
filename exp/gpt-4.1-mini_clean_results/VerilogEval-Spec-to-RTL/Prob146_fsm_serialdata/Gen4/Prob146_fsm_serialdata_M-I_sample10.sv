module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for 8 bits
    reg [7:0] data_shift;

    // Clock enable for updating data registers during RECEIVE only
    wire ce_receive = (state == RECEIVE);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;

            // Update bit_count only in RECEIVE state
            if (ce_receive)
                bit_count <= bit_count + 1'b1;
            else if (state == IDLE && in == 1'b0)
                bit_count <= 3'd0; // Reset bit count on start bit detection

            // Shift data in LSB first during RECEIVE state only
            if (ce_receive)
                data_shift <= {in, data_shift[7:1]};
            else if (state == IDLE && in == 1'b0)
                data_shift <= 8'd0; // Reset data_shift on start bit

            // Capture output byte only on STOP state with valid stop bit
            if (state == STOP && in == 1'b1)
                out_byte <= data_shift;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
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
                    next_state = IDLE;     // Correct stop bit
                else
                    next_state = WAIT_STOP; // Wait for stop bit
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

    // done signal combinational logic:
    // Assert done only for one cycle when stop bit is correctly detected
    assign done = (state == STOP) && (in == 1'b1);

endmodule