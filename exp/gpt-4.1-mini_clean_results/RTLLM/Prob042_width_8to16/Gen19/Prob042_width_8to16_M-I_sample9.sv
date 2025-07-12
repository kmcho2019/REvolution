module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;

    reg [7:0] data_lock;      // Stores first byte
    reg [7:0] data_second;    // Stores second byte, latched on second valid_in

    reg        output_ready;  // Flag to indicate output valid_out/data_out should be produced next cycle

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE; // After second byte received, return to IDLE
                else
                    next_state = WAIT_SECOND;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            data_second  <= 8'd0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
            output_ready <= 1'b0;
        end else begin
            state <= next_state;

            valid_out <= 1'b0; // default deassert output valid; will assert below if needed

            case (state)
                IDLE: begin
                    output_ready <= 1'b0;
                    if (valid_in) begin
                        data_lock <= data_in; // latch first byte
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_second  <= data_in;    // latch second byte
                        output_ready <= 1'b1;       // indicate output should be produced next cycle
                    end
                end

                default: begin
                    output_ready <= 1'b0;
                end
            endcase

            // Generate output in cycle after second valid_in
            if (output_ready) begin
                data_out  <= {data_lock, data_second};
                valid_out <= 1'b1;
                output_ready <= 1'b0; // clear output_ready after outputting
            end
        end
    end

endmodule