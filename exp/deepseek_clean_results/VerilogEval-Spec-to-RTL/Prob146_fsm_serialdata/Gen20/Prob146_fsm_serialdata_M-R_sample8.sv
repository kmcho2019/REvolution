module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding (better timing)
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg bit_count_done;

    // Continuous assignment for shift operation
    wire [7:0] next_shift = {in, shift_reg[7:1]};

    // Combinational done signal
    assign done = (state == STOP) && in;

    // Registered bit_count comparison
    always @(posedge clk) begin
        if (reset) begin
            bit_count_done <= 0;
        end else begin
            bit_count_done <= (bit_count == 3'd7);
        end
    end

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:    next_state = in ? IDLE : RECEIVE;
            RECEIVE: next_state = bit_count_done ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : IDLE;  // Simplified error handling
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (next_state == RECEIVE)
                        shift_reg <= 0;
                end

                RECEIVE: begin
                    shift_reg <= next_shift;
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    out_byte <= shift_reg;
                end
            endcase
        end
    end

endmodule