module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam BYTE1  = 2'd1;
    localparam BYTE2  = 2'd2;
    localparam BYTE3  = 2'd3;

    reg [1:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Sequential logic: state and bytes registers, done and out_bytes outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default done low

            case (state)
                IDLE: begin
                    // latch byte1 only if in[3]==1 (start byte detected)
                    if (next_state == BYTE1) byte1 <= in;
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                end
                BYTE3: begin
                    // done asserted only one cycle here
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, byte3};
                end
                default: begin
                    // default do nothing
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule