module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] out_reg;
    reg done_reg;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  if (in[3]) next_state = BYTE1;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output generation logic
    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 24'bx;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;
            case (state)
                IDLE: if (in[3]) out_reg[23:16] <= in;
                BYTE1: out_reg[15:8] <= in;
                BYTE2: begin
                    out_reg[7:0] <= in;
                    done_reg <= 1'b1;
                end
                default: begin
                    out_reg <= 24'bx;
                    done_reg <= 1'b0;
                end
            endcase
        end
    end

    // Output assignments
    assign out_bytes = out_reg;
    assign done = done_reg;

endmodule