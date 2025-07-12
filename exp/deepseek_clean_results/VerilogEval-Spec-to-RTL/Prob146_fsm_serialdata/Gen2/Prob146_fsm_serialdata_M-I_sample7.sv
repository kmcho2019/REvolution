module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states (better for timing)
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state, next_state;
    reg [1:0] bit_count;  // Reduced from 3 to 2 bits
    reg [7:0] shift_reg;
    reg shift_enable;     // Enable signal for power reduction
    
    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 2'b00;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            shift_enable <= 0;
        end else begin
            // Default assignments
            shift_enable <= 0;
            done <= 0;
            
            case (state)
                IDLE: begin
                    if (in == 0) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 2'b00;
                        shift_enable <= 1;
                    end
                end
                
                RECEIVE: begin
                    shift_enable <= 1;
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    end
                    
                    if (bit_count == 2'b11) begin // After 7 shifts (0-7)
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end else begin // Missing stop bit - wait here
                        // Stay in STOP until we see stop bit
                    end
                end
            endcase
        end
    end

endmodule