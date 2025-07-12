module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else
            state <= next_state;
    end

    // Byte registers with enables
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            case (state)
                WAIT_SYNC: if (in[3]) byte1 <= in;
                BYTE2: byte2 <= in;
                BYTE3: byte3 <= in;
            endcase
        end
    end

    // done and out_bytes registers
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            if (state == BYTE3) begin
                done <= 1'b1;
                out_bytes <= {byte1, byte2, in};
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = (in[3]) ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule