module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;
    localparam ERROR  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111; // Start counting from 7 down to 0
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in == 0) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b111; // Reset counter
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    if (bit_count == 3'b000) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end else begin // Missing stop bit
                        state <= ERROR;
                    end
                end
                
                ERROR: begin
                    if (in) begin // Found stop bit
                        state <= IDLE;
                    end
                    done <= 0;
                end
            endcase
        end
    end

endmodule