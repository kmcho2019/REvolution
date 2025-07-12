module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // One-hot FSM state encoding (7 states)
    localparam SEARCH0 = 7'b0000001; // no match yet
    localparam SEARCH1 = 7'b0000010; // matched '1'
    localparam SEARCH2 = 7'b0000100; // matched '11'
    localparam SEARCH3 = 7'b0001000; // matched '110'
    localparam SHIFT   = 7'b0010000; // shifting delay bits (4 cycles)
    localparam COUNT   = 7'b0100000; // counting delay
    localparam DONE    = 7'b1000000; // done, waiting for ack

    reg [6:0] state, next_state;
    reg [1:0] shift_count, next_shift_count;

    // Combinational next state logic
    always @(*) begin
        next_state = 7'b0000000; // default to invalid (safe)
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
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            state[5]: // COUNT
                next_state = done_counting ? DONE : COUNT;
            state[6]: // DONE
                next_state = ack ? SEARCH0 : DONE;
            default:
                next_state = SEARCH0;
        endcase
    end

    // Combinational next shift_count logic
    always @(*) begin
        if (state == SHIFT)
            next_shift_count = shift_count + 2'd1;
        else
            next_shift_count = 2'd0;
    end

    // Sequential logic: state and shift_count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
        end
    end

    // Register outputs for glitch reduction (Moore outputs)
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule