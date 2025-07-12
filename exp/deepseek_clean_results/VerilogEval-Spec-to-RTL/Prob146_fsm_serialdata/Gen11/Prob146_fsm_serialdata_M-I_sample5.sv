module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot FSM states
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire bit_count_done = (bit_count == 3'b111);
    reg data_valid;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            data_valid <= 1'b0;
        end else begin
            state <= next_state;
            data_valid <= 1'b0;
            
            case (1'b1) // synthesis parallel_case
                state[0]: begin // IDLE
                    bit_count <= 3'b0;
                    done <= 1'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                        data_valid <= 1'b1;
                    end
                end
                
                state[1]: begin // RECEIVE
                    if (data_valid) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end
                    data_valid <= 1'b1;
                end
                
                state[2]: begin // STOP
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end else begin
                        done <= 1'b0;
                    end
                    data_valid <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = IDLE; // Default
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = (in == 1'b0) ? RECEIVE : IDLE;
            state[1]: next_state = bit_count_done ? STOP : RECEIVE;
            state[2]: next_state = (in == 1'b1) ? IDLE : STOP;
        endcase
    end

endmodule