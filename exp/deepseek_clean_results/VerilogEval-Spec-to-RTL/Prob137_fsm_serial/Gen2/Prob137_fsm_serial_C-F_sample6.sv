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
    reg [1:0] next_state_reg;

    // Register next_state to improve timing
    always @(posedge clk) begin
        if (reset) begin
            next_state_reg <= IDLE;
        end else begin
            next_state_reg <= next_state;
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
            data_shift <= 8'b0;
        end else begin
            state <= next_state_reg;
            
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
                    done_reg <= in; // Assert done only if stop bit is valid
                end
                ERROR: begin
                    // No register updates needed while waiting for stop bit
                end
            endcase
        end
    end

    // Next state logic (combinational)
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