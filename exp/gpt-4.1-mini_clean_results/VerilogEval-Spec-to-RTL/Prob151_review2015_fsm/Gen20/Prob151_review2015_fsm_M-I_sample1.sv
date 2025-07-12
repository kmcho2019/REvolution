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

    // One-hot state encoding
    localparam SEARCH0 = 10'b0000000001;
    localparam SEARCH1 = 10'b0000000010;
    localparam SEARCH2 = 10'b0000000100;
    localparam SEARCH3 = 10'b0000001000;
    localparam SHIFT0  = 10'b0000010000;
    localparam SHIFT1  = 10'b0000100000;
    localparam SHIFT2  = 10'b0001000000;
    localparam SHIFT3  = 10'b0010000000;
    localparam COUNT   = 10'b0100000000;
    localparam DONE    = 10'b1000000000;

    reg [9:0] state, next_state;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        case (1'b1) // one-hot decode style
            state[0]: // SEARCH0
                next_state = data ? SEARCH1 : SEARCH0;
            state[1]: // SEARCH1
                next_state = data ? SEARCH2 : SEARCH0;
            state[2]: // SEARCH2
                next_state = (~data) ? SEARCH3 : SEARCH2;
            state[3]: // SEARCH3
                next_state = data ? SHIFT0 : SEARCH0;
            state[4]: // SHIFT0
                next_state = SHIFT1;
            state[5]: // SHIFT1
                next_state = SHIFT2;
            state[6]: // SHIFT2
                next_state = SHIFT3;
            state[7]: // SHIFT3
                next_state = COUNT;
            state[8]: // COUNT
                next_state = done_counting ? DONE : COUNT;
            state[9]: // DONE
                next_state = ack ? SEARCH0 : DONE;
            default:
                next_state = SEARCH0; // safe default
        endcase
    end

    // Output logic (Moore outputs)
    assign shift_ena = |(state[4:7]);  // SHIFT0 to SHIFT3
    assign counting  = state[8];        // COUNT
    assign done      = state[9];        // DONE

endmodule