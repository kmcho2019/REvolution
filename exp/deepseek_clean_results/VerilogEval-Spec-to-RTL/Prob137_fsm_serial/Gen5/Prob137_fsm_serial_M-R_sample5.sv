module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP_WAIT = 4'b0100;
    // 4'b1000 unused (for future expansion)

    reg [3:0] state;
    reg [1:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Continuous assignments for next state logic
    wire start_detected = (state == IDLE) & (in == 1'b0);
    wire byte_complete = (state == RECEIVE) & (bit_count == 2'b11);
    wire stop_valid = (state == STOP_WAIT) & (in == 1'b1);

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 2'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;  // Default clear

            case (state)
                IDLE: begin
                    if (start_detected) begin
                        state <= RECEIVE;
                        bit_count <= 2'b0;
                    end
                end

                RECEIVE: begin
                    shift_reg[bit_count] <= in;  // Direct bit assignment
                    if (byte_complete) begin
                        state <= STOP_WAIT;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP_WAIT: begin
                    if (stop_valid) begin
                        state <= IDLE;
                        done_reg <= 1'b1;  // Only set when valid stop
                    end
                    // Else stay in STOP_WAIT
                end

                default: state <= IDLE;
            endcase
        end
    end

    assign done = done_reg;

endmodule