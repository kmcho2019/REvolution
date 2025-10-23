module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    localparam ERROR  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_next;

    // State transition logic (registered to improve timing)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= done_next;
            
            case (state)
                IDLE: begin
                    if (in == 0) begin
                        shift_reg <= 0;
                        bit_count <= 3'b111;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count - 1;
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                    end
                end
            endcase
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        done_next = 0;
        
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                if (bit_count == 0) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in) begin
                    next_state = IDLE;
                    done_next = 1;
                end else begin
                    next_state = ERROR;
                end
            end
            
            ERROR: begin
                if (in) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule