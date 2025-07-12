module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // One-hot state encoding
    localparam WAIT_SYNC = 3'b001;
    localparam BYTE2     = 3'b010;
    localparam BYTE3     = 3'b100;

    reg [2:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    wire byte1_en = (state == WAIT_SYNC) & in[3];
    wire byte2_en = (state == BYTE2);
    wire byte3_en = (state == BYTE3);
    wire done_assert = (state == BYTE3);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else
            state <= next_state;
    end

    // Byte registers with clock enables
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            if (byte1_en)
                byte1 <= in;
            if (byte2_en)
                byte2 <= in;
            if (byte3_en)
                byte3 <= in;
        end
    end

    // done register: pulse for one cycle when 3rd byte received
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= done_assert;
    end

    // out_bytes register updated only when done asserted
    always @(posedge clk) begin
        if (reset)
            out_bytes <= 24'd0;
        else if (done_assert)
            out_bytes <= {byte1, byte2, in};
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule