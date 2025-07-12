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

    // One-hot state encoding (7 states)
    localparam SEARCH0 = 7'b0000001; // no bits matched yet
    localparam SEARCH1 = 7'b0000010; // matched first '1'
    localparam SEARCH2 = 7'b0000100; // matched '11'
    localparam SEARCH3 = 7'b0001000; // matched '110'
    localparam SHIFT   = 7'b0010000; // shifting in 4 bits
    localparam COUNT   = 7'b0100000; // waiting for counting done
    localparam DONE    = 7'b1000000; // timer done, waiting for ack

    reg [6:0] state, next_state;
    reg [2:0] shift_count; // 3 bits to count from 0 to 3

    wire shift_count_enable = (state == SHIFT);

    // Sequential block: state register and shift_count with synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (shift_count_enable) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Combinational block: next state logic
    always @(*) begin
        case (state)
            SEARCH0: next_state = data      ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = data      ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = ~data     ? SEARCH3 : SEARCH2; // expect '0'
            SEARCH3: next_state = data      ? SHIFT   : SEARCH0; // final '1'
            SHIFT:   next_state = (shift_count == 3'd3) ? COUNT : SHIFT;
            COUNT:   next_state = done_counting ? DONE : COUNT;
            DONE:    next_state = ack       ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs derived combinationally from one-hot state signals
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule