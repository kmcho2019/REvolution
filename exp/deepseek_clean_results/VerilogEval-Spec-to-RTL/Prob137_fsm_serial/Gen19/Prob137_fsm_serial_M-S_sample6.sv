module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit
        RECEIVE,   // Receiving 8 data bits
        STOP       // Checking stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Shift register (no clock gating)
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
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;
            end
            
            RECEIVE: begin
                if (bit_count == 3'd7) next_state = STOP;
            end
            
            STOP: begin
                if (in) next_state = IDLE;
            end
        endcase
    end

    // Done is high when we're in STOP state and see a valid stop bit
    assign done = (state == STOP) && in;

endmodule