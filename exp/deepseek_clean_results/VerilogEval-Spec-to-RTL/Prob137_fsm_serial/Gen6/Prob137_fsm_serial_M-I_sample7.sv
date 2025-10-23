module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;
    reg data_en, count_en;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;  // Default to 0

            // Conditional data register update
            if (data_en) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
            end

            // Conditional bit counter update
            if (count_en) begin
                bit_count <= bit_count + 1;
            end

            // Special case for STOP state
            if (state == STOP && in) begin
                done_reg <= 1'b1;  // Valid stop bit
                bit_count <= 3'b0; // Reset counter
            end
        end
    end

    // Combinational next state and enable logic
    always @(*) begin
        // Default values
        next_state = state;
        data_en = 1'b0;
        count_en = 1'b0;

        case (state)
            IDLE: begin
                if (~in) begin
                    next_state = RECEIVE;
                    data_en = 1'b1;  // Capture first bit
                    count_en = 1'b1; // Start counting
                end
            end

            RECEIVE: begin
                data_en = 1'b1;      // Continue capturing bits
                count_en = 1'b1;     // Continue counting
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                    data_en = 1'b0;  // Stop capturing
                    count_en = 1'b0; // Stop counting
                end
            end

            STOP: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    // Wait for stop bit (merged WAIT functionality)
                    next_state = STOP;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule