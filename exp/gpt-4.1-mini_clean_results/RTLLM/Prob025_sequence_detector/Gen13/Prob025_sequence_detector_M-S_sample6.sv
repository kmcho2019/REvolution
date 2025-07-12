module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: number of matched bits in sequence "1001"
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            2'd0: // no match
                next_state = data_in ? 2'd1 : 2'd0;
            2'd1: // matched '1'
                next_state = data_in ? 2'd1 : 2'd2;
            2'd2: // matched '10'
                next_state = data_in ? 2'd3 : 2'd0;
            2'd3: // matched '100'
                next_state = data_in ? 2'd1 : 2'd0;
            default:
                next_state = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= 2'd0;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected is asserted when sequence "1001" is matched
            // This happens when at state 3 and input bit is '1' (i.e., moving from '100' + '1')
            sequence_detected <= (state == 2'd3) && data_in;
        end
    end

endmodule