module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states - optimized 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111; // Count down from 7 to 0
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            shift_enable <= 0;
        end else begin
            // Default values
            done <= 0;
            shift_enable <= 0;

            case (state)
                IDLE: begin
                    if (in == 0) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b111;
                        shift_enable <= 1;
                    end
                end
                
                RECEIVE: begin
                    if (bit_count[0]) begin // Simple LSB check
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                    shift_enable <= 1;
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg; // Pipelined update
                        done <= 1;
                        state <= IDLE;
                    end else begin
                        // Wait for stop bit (simplified from ERROR state)
                        state <= STOP;
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