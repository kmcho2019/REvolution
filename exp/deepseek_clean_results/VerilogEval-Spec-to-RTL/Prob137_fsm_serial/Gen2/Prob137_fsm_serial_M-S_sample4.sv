module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE     = 1'b0;
    localparam RECEIVING = 1'b1;

    reg state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVING) begin
                if (bit_count != 3'b111) begin
                    data_reg <= {in, data_reg[7:1]};  // Shift right, LSB first
                    bit_count <= bit_count + 1;
                end else begin
                    bit_count <= 3'b0;  // Reset counter after 8 bits
                end
            end
        end
    end

    // Next state logic and output
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVING : IDLE;
            end
            
            RECEIVING: begin
                // Stay in RECEIVING until we've seen 8 bits and stop bit is 1
                next_state = (bit_count == 3'b111 && in == 1'b1) ? IDLE : RECEIVING;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Done is asserted when we've received a complete byte with valid stop bit
    assign done = (state == RECEIVING && bit_count == 3'b111 && in == 1'b1);

endmodule