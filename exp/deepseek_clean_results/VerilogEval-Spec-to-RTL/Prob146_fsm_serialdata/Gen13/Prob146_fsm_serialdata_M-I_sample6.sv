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
    reg [1:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

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
            done <= 0;
            shift_enable <= 0;

            case (state)
                IDLE: begin
                    if (in == 0) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 2'b00;
                        shift_enable <= 1;
                    end
                end
                
                RECEIVE: begin
                    if (bit_count == 2'b11) begin // Received 8 bits (0-7)
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                        shift_enable <= 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end else begin
                        // Wait for stop bit (implicit error handling)
                        // No need for separate ERROR state
                    end
                end
            endcase

            // Shift register with enable
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]}; // LSB first
            end
        end
    end

endmodule