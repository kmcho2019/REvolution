module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;
    
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg [1:0] state, next_state;
    
    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done output each cycle
            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    // start bit confirmed, prepare for data bits
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    state <= DATA;
                end
                DATA: begin
                    // shift in data bits, LSB first
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        // valid stop bit
                        out_byte <= data_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // invalid stop bit, wait here until stop bit detected
                        state <= STOP;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule