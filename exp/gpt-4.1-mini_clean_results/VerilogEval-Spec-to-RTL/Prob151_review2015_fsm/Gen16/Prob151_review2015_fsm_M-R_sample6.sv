module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot encoded states
    localparam SEARCH0 = 7'b000_0001; // no match yet
    localparam SEARCH1 = 7'b000_0010; // matched '1'
    localparam SEARCH2 = 7'b000_0100; // matched '11'
    localparam SEARCH3 = 7'b000_1000; // matched '110'
    localparam SHIFT   = 7'b001_0000; // shifting delay bits (4 cycles)
    localparam COUNT   = 7'b010_0000; // counting delay
    localparam DONE    = 7'b100_0000; // done, waiting for ack

    reg [6:0] state, next_state;

    // 3-bit shift counter: counts 0 to 3 (4 cycles) during SHIFT state
    reg [1:0] shift_count;
    wire shift_max = (shift_count == 2'd3);

    // Next state logic using one-hot encoding and explicit signals
    always @(*) begin
        case (1'b1)
            state[0]: // SEARCH0
                next_state = data ? SEARCH1 : SEARCH0;
            state[1]: // SEARCH1
                next_state = data ? SEARCH2 : SEARCH0;
            state[2]: // SEARCH2
                next_state = (~data) ? SEARCH3 : SEARCH2;
            state[3]: // SEARCH3
                next_state = data ? SHIFT : SEARCH0;
            state[4]: // SHIFT
                next_state = shift_max ? COUNT : SHIFT;
            state[5]: // COUNT
                next_state = done_counting ? DONE : COUNT;
            state[6]: // DONE
                next_state = ack ? SEARCH0 : DONE;
            default:
                next_state = SEARCH0;
        endcase
    end

    // Shift count logic: count from 0 to 3 when in SHIFT state, reset otherwise
    always @(posedge clk) begin
        if (reset)
            shift_count <= 2'd0;
        else if (state == SHIFT)
            shift_count <= shift_count + 2'd1;
        else
            shift_count <= 2'd0;
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH0;
        else
            state <= next_state;
    end

    // Outputs are Moore-type, combinational based on one-hot state encoding
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule