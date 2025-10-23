module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP
    } state_t;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default value
            
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in == 1) begin
                        done <= 1;
                        state <= IDLE;
                    end
                    // Stay in STOP until we see a 1
                end
            endcase
        end
    end

endmodule