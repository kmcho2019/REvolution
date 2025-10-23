module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_next;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_next;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b111;
                    if (in == 1'b0) begin
                        next_state <= RECEIVE;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 3'b0) begin
                        next_state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done_next <= 1'b1;
                        next_state <= IDLE;
                    end else begin
                        // Wait for stop bit without extra ERROR state
                        done_next <= 1'b0;
                    end
                end
                
                default: next_state <= IDLE;
            endcase
            
            // Clear done after one cycle
            if (done) done_next <= 1'b0;
        end
    end

    // Next state logic (combinatorial)
    always @(*) begin
        next_state = state;
        done_next = 1'b0;
        
        case (state)
            IDLE: if (in == 1'b0) next_state = RECEIVE;
            RECEIVE: if (bit_count == 3'b0) next_state = STOP;
            STOP: begin
                if (in) begin
                    done_next = 1'b1;
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule