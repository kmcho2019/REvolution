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
    reg [1:0] bit_count;  // Now 2 bits instead of 3
    reg [7:0] shift_reg;
    reg shift_enable;     // Enable signal for shift register

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 2'b00;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    shift_enable <= 1'b0;
                    if (in == 1'b0) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 2'b00;
                        shift_enable <= 1'b1;
                    end
                end
                
                RECEIVE: begin
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    end
                    
                    // Modified counting logic for 2-bit counter
                    if (bit_count == 2'b11) begin
                        state <= STOP;
                        shift_enable <= 1'b0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin // Missing stop bit - wait here
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule