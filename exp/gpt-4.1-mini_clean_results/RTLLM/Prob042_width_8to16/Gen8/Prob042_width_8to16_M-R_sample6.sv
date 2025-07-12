module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg        state, next_state;
    reg [7:0]  data_lock;     // Store first 8-bit data
    reg        valid_in_d;    // Delayed version of valid_in for rising edge detection
    reg        valid_out_next;
    reg [15:0] data_out_next;

    // Rising edge detector for valid_in
    wire valid_in_rise = valid_in & ~valid_in_d;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            valid_in_d   <= 1'b0;
            valid_out    <= 1'b0;
            data_out     <= 16'd0;
            valid_out_next <= 1'b0;
            data_out_next  <= 16'd0;
        end else begin
            state      <= next_state;
            valid_in_d <= valid_in;

            valid_out  <= valid_out_next;
            data_out   <= data_out_next;
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default assignments
        next_state       = state;
        valid_out_next   = 1'b0;
        data_out_next    = 16'd0;

        case (state)
            IDLE: begin
                if (valid_in_rise) begin
                    // Latch first data and move to WAIT_SECOND
                    next_state = WAIT_SECOND;
                end
            end

            WAIT_SECOND: begin
                if (valid_in_rise) begin
                    // Second data received: output concatenation next cycle
                    valid_out_next = 1'b1;
                    data_out_next  = {data_lock, data_in};
                    next_state     = IDLE;
                end
            end
        endcase
    end

    // Latch data_lock on first valid input rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'd0;
        end else if (state == IDLE && valid_in_rise) begin
            data_lock <= data_in;
        end
    end

endmodule