module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg done_reg;
    reg [7:0] data_shift;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                end
                RECEIVE: begin
                    bit_count <= bit_count + 1;
                    data_shift <= {in, data_shift[7:1]}; // LSB first
                end
                STOP: begin
                    done_reg <= in; // Assert done only if stop bit is 1
                end
                ERROR: begin
                    // Wait for stop bit, no action needed
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end
            STOP: begin
                next_state = in ? IDLE : ERROR;
            end
            ERROR: begin
                next_state = in ? IDLE : ERROR;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule