module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding for better timing
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg done_reg;
    reg [7:0] data_shift;
    reg data_shift_en;  // Clock gating control

    // Clock gating for data_shift
    always @(posedge clk) begin
        if (data_shift_en) begin
            data_shift <= {in, data_shift[7:1]}; // LSB first
        end
    end

    // State transition with registered next_state
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
            data_shift_en <= 1'b0;
        end else begin
            state <= next_state;
            
            case (1'b1) // synthesis parallel_case
                state[0]: begin // IDLE
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                    data_shift_en <= 1'b0;
                end
                state[1]: begin // RECEIVE
                    bit_count <= bit_count + 1;
                    data_shift_en <= 1'b1;
                end
                state[2]: begin // STOP
                    done_reg <= in;
                    data_shift_en <= 1'b0;
                end
                state[3]: begin // ERROR
                    data_shift_en <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = (in == 1'b0) ? RECEIVE : IDLE;
            state[1]: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            state[2]: next_state = in ? IDLE : ERROR;
            state[3]: next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule