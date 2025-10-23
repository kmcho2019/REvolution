module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized FSM states
    localparam IDLE    = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_next;

    // Registered next_state for better timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_next;
            
            if (state == RECEIVE) begin
                // Left shift implementation (better timing)
                shift_reg <= {shift_reg[6:0], in};
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Capture output only when done is asserted
            if (done_next) begin
                out_byte <= shift_reg;
            end
        end
    end

    // Combinational next state and output logic
    always @(*) begin
        next_state = state;
        done_next = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin  // Start bit detected
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin  // Received all 8 bits
                    if (in == 1'b1) begin  // Valid stop bit
                        done_next = 1'b1;
                    end
                    next_state = IDLE;  // Return to IDLE regardless of stop bit
                end
            end
        endcase
    end

endmodule