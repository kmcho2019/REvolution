module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state, next_state;
    reg [1:0] bit_count;  // Now 2 bits instead of 3
    reg [7:0] data_reg;
    reg done_reg;
    reg data_reg_en;      // Enable for data register

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 2'b0;
            done_reg <= 1'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;

            case (1'b1)  // Synthesis will optimize this to parallel case
                state[0]: begin // IDLE
                    bit_count <= 2'b0;
                end
                
                state[1]: begin // RECEIVE
                    if (data_reg_en) begin
                        data_reg <= {in, data_reg[7:1]};  // LSB first
                    end
                    bit_count <= bit_count + 1;
                end
                
                state[2]: begin // STOP
                    if (in) begin
                        done_reg <= 1'b1;  // Valid stop bit
                    end
                end
                
                state[3]: begin // WAIT
                    // No operations needed
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;  // Default to current state
        data_reg_en = 1'b0;

        case (1'b1)  // Parallel case
            state[0]: begin // IDLE
                if (~in) begin
                    next_state = RECEIVE;
                    data_reg_en = 1'b1;
                end
            end
            
            state[1]: begin // RECEIVE
                data_reg_en = 1'b1;
                if (&bit_count) begin  // bit_count == 3 (after counting 0-7)
                    next_state = STOP;
                end
            end
            
            state[2]: begin // STOP
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            
            state[3]: begin // WAIT
                if (in) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign done = done_reg;

endmodule