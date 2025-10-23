module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output          done
);

    // FSM states - binary encoding
    localparam WAIT_SYNC = 2'b00;
    localparam BYTE2     = 2'b01;
    localparam BYTE3     = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2;

    // Clock enable signals - only update when state changes or bytes load
    wire state_chg = (state != next_state);
    wire load_byte1 = (state == WAIT_SYNC) && in[3];
    wire load_byte2 = (state == BYTE2);
    wire load_byte3 = (state == BYTE3);
    wire enable_regs = state_chg || load_byte1 || load_byte2 || load_byte3;

    // FSM state register with clock enable
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else if (state_chg)
            state <= next_state;
    end

    // Byte registers with clock enable
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
        end else if (enable_regs) begin
            if (load_byte1)
                byte1 <= in;
            if (load_byte2)
                byte2 <= in;
        end
    end

    // out_bytes updated only on load_byte3 cycle with clock enable
    always @(posedge clk) begin
        if (reset)
            out_bytes <= 24'd0;
        else if (load_byte3)
            out_bytes <= {byte1, byte2, in};
    end

    // done is combinational: asserted when FSM transitions from BYTE3 to WAIT_SYNC (i.e., one cycle after 3rd byte capture)
    assign done = (state == BYTE3);

    // Next state combinational logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule