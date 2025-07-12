module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic combinational
    always @(*) begin
        done = 1'b0;  // Default done is low unless 3rd byte reached
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end

            BYTE1: begin
                next_state = BYTE2;
            end

            BYTE2: begin
                next_state = IDLE;
                done = 1'b1; // Pulse done after 3rd byte
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential state update and done register update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // 'done' is registered in combinational block, so update on clock edge
            done <= done; // keep done updated properly
        end
    end

endmodule