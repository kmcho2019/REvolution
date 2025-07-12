module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state, next_state;
    reg [1:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;
    reg done_next;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 2'b00;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            // Default assignments
            shift_enable <= 1'b0;
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (!in) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 2'b00;
                        shift_enable <= 1'b1;
                    end
                end
                
                RECEIVE: begin
                    if (bit_count == 2'b11) begin // Received 8 bits
                        state <= STOP;
                        shift_enable <= 1'b0;
                    end else begin
                        bit_count <= bit_count + 1;
                        shift_enable <= 1'b1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin // Missing stop bit
                        state <= WAIT;
                    end
                end
                
                WAIT: begin
                    if (in) begin // Found stop bit
                        state <= IDLE;
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