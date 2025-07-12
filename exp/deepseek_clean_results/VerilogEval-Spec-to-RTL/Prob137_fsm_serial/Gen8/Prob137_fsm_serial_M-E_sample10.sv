module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] bit_counter;  // Counts 0-8 (need extra bit for 8 count)
    reg [7:0] data_reg;
    reg done_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 4'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;

            case (state)
                IDLE: begin
                    bit_counter <= 4'b0;
                end

                RECEIVE: begin
                    // Capture bit in parallel based on counter
                    if (bit_counter < 4'b1000) begin
                        data_reg[bit_counter[2:0]] <= in;
                    end
                    bit_counter <= bit_counter + 1;
                end

                STOP: begin
                    if (in) begin
                        done_reg <= 1'b1;
                    end
                    bit_counter <= 4'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (~in) ? RECEIVE : IDLE;
            end

            RECEIVE: begin
                // Transition to STOP when we've captured all 8 bits
                // or early if we detect a potential stop bit
                if (bit_counter == 4'b1000 || 
                    (bit_counter == 4'b0111 && in)) begin
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end

            STOP: begin
                next_state = in ? IDLE : RECEIVE;
            end

            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule