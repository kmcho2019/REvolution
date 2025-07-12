module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            RECEIVE: begin
                next_state = (bit_count == 3'b0) ? STOP : RECEIVE;
            end
            STOP: begin
                next_state = in ? IDLE : STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b111;
                    done_reg <= 1'b0;
                    if (!in) begin
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count - 1;
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done_reg <= 1'b1;
                    end else begin
                        done_reg <= 1'b0;
                    end
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule