module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // One-hot state encoding for 3 states
    localparam WAIT_SYNC = 3'b001;
    localparam BYTE2     = 3'b010;
    localparam BYTE3     = 3'b100;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else
            state <= next_state;
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

    // Data bytes shift register: load byte1 only at sync, then shift
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            if (state == WAIT_SYNC) begin
                if (in[3]) begin
                    byte1 <= in;
                    byte2 <= 8'd0;
                    byte3 <= 8'd0;
                end
            end else begin
                // Shift bytes for BYTE2 and BYTE3 states
                byte1 <= byte1;
                byte2 <= (state == BYTE2) ? in : byte2;
                byte3 <= (state == BYTE3) ? in : byte3;
            end
        end
    end

    // done is combinational: asserted when state is BYTE3, i.e., after receiving 3rd byte
    assign done = (state == BYTE3);

    // out_bytes registered and updated synchronously when done asserted (BYTE3 state)
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'd0;
        end else if (done) begin
            out_bytes <= {byte1, byte2, byte3};
        end
    end

endmodule