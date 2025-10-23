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

    // Binary encoded states
    localparam SEARCH0 = 3'd0;
    localparam SEARCH1 = 3'd1;
    localparam SEARCH2 = 3'd2;
    localparam SEARCH3 = 3'd3;
    localparam SHIFT   = 3'd4;
    localparam COUNT   = 3'd5;
    localparam DONE    = 3'd6;

    reg [2:0] state, next_state;
    reg [1:0] shift_count; // 2 bits sufficient for counting 4 cycles (0 to 3)

    // State and counter sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT) begin
                if (shift_count == 2'd3)
                    shift_count <= 2'd0;
                else
                    shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            SEARCH0: 
                next_state = data ? SEARCH1 : SEARCH0;
            SEARCH1:
                next_state = data ? SEARCH2 : SEARCH0;
            SEARCH2:
                next_state = (~data) ? SEARCH3 : SEARCH2; // stay in SEARCH2 if data==1 (allows overlapping pattern)
            SEARCH3:
                next_state = data ? SHIFT : SEARCH0; // complete pattern 1101
            SHIFT:
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:
                next_state = done_counting ? DONE : COUNT;
            DONE:
                next_state = ack ? SEARCH0 : DONE;
            default:
                next_state = SEARCH0;
        endcase
    end

    // Outputs decoded combinationally from state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule