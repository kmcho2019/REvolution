module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state, state_reg;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // Register next_state to improve timing
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= IDLE;
        end else begin
            state_reg <= next_state;
        end
    end

    // Main FSM with registered state
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            state <= state_reg;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done <= 1'b0;
                    shift_enable <= 1'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                        shift_enable <= 1'b1;
                    end
                end
                
                RECEIVE: begin
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]};  // Shift right (LSB first)
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in == 1'b1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end else begin
                        done <= 1'b0;
                    end
                    shift_enable <= 1'b0;
                end
            endcase
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                // Wait for stop bit if missing, then return to IDLE
                next_state = (in == 1'b1) ? IDLE : STOP;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule