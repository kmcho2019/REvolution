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

    // Shift register (always enabled)
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // State register and counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Update counter only in RECEIVE state
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
            
            // Update done signal when valid stop bit is detected
            done_reg <= (state == RECEIVE) && (bit_count == 3'd7) && in;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (!in) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = in ? IDLE : STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule