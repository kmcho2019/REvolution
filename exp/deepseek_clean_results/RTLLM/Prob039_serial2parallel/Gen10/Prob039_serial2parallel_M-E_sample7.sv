module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        COLLECTING,
        READY
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_ptr;
    reg [7:0] data_buffer;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            dout_valid <= 1'b0;
        end else begin
            state <= next_state;
            
            // Registered valid signal (delayed by 1 cycle)
            dout_valid <= (next_state == READY);
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = din_valid ? COLLECTING : IDLE;
            end
            
            COLLECTING: begin
                if (bit_ptr == 3'd7 && din_valid)
                    next_state = READY;
                else
                    next_state = COLLECTING;
            end
            
            READY: begin
                next_state = din_valid ? COLLECTING : IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Data collection logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buffer <= 8'b0;
            bit_ptr <= 3'b0;
            dout_parallel <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (din_valid) begin
                        data_buffer <= {7'b0, din_serial};
                        bit_ptr <= 3'd1;
                    end
                end
                
                COLLECTING: begin
                    if (din_valid) begin
                        // Circular insertion (MSB first)
                        data_buffer <= {data_buffer[6:0], din_serial};
                        bit_ptr <= bit_ptr + 1'b1;
                    end
                end
                
                READY: begin
                    dout_parallel <= data_buffer;
                    bit_ptr <= 3'b0;
                    if (din_valid) begin
                        data_buffer <= {7'b0, din_serial};
                        bit_ptr <= 3'd1;
                    end
                end
            endcase
        end
    end

endmodule