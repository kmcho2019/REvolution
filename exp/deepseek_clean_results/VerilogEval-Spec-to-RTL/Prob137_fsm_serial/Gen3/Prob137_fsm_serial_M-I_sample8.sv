module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition and done signal logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
                done = 1'b0;
            end
            RECEIVE: begin
                next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
                done = 1'b0;
            end
            STOP: begin
                next_state = (in == 1) ? IDLE : WAIT;
                done = (in == 1);
            end
            WAIT: begin
                next_state = (in == 1) ? IDLE : WAIT;
                done = 1'b0;
            end
            default: begin
                next_state = IDLE;
                done = 1'b0;
            end
        endcase
    end

    // Bit counter (only increments in RECEIVE state)
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end else if (next_state != RECEIVE) begin
            bit_count <= 3'b0;
        end
    end

    // Shift register (only updates when in changes in RECEIVE state)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]}; // LSB first
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule