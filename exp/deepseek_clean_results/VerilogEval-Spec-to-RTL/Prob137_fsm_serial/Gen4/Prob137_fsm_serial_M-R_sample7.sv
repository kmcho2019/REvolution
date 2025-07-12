module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP   = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Datapath (bit counting and shifting)
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                    end
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                default: begin
                    // No change in other states
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end
            end
            RECEIVE: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    // Stay in STOP until we see 1
                    next_state = STOP;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational)
    assign done = (state == STOP) && (in == 1'b1);

endmodule