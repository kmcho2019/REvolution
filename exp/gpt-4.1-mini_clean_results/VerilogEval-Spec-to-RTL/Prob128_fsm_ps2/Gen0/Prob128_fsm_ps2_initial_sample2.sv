module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding
    localparam SEARCH = 2'b00;
    localparam BYTE2  = 2'b01;
    localparam BYTE3  = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case(state)
            SEARCH: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = SEARCH;
            end

            BYTE2: begin
                next_state = BYTE3;
            end

            BYTE3: begin
                next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic for state and done signal
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted for one cycle after third byte received, i.e. when current state is BYTE3
            done <= (state == BYTE3);
        end
    end

endmodule