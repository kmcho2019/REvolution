module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Next state logic using continuous assignments
    wire start_detected = (state == IDLE) & (in == 1'b0);
    wire all_bits_received = (bit_count == 3'b111);
    wire valid_stop = (in == 1'b1);

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;  // Default to 0, set only when needed
            
            case (1'b1)  // Synthesis will optimize this case statement
                state[0]: begin // IDLE
                    bit_count <= 3'b0;
                    if (start_detected) begin
                        state <= RECEIVE;
                        shift_reg <= 8'b0;
                    end
                end
                
                state[1]: begin // RECEIVE
                    shift_reg <= {shift_reg[6:0], in};  // Simpler shift operation
                    bit_count <= bit_count + 1;
                    if (all_bits_received) begin
                        state <= STOP;
                    end
                end
                
                state[2]: begin // STOP
                    if (valid_stop) begin
                        state <= IDLE;
                        done_reg <= 1'b1;
                    end
                    // Stay in STOP until we get valid stop bit
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    assign done = done_reg;

endmodule