module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE       = 3'b001;
    localparam RECEIVE    = 3'b010;
    localparam WAIT_STOP  = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire valid_stop;

    // Continuous assignments
    assign valid_stop = (state == WAIT_STOP) & in;
    assign done = valid_stop;

    // State transitions and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (!in) begin
                        state <= RECEIVE;
                        shift_reg <= 0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 3'd7) begin
                        state <= WAIT_STOP;
                        bit_count <= 0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                WAIT_STOP: begin
                    if (in) begin
                        state <= IDLE;
                        out_byte <= shift_reg;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule