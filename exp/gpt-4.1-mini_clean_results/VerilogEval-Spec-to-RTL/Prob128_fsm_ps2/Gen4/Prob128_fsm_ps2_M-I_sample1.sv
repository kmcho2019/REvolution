module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // One-hot state encoding
    localparam SEARCH = 3'b001;
    localparam BYTE2  = 3'b010;
    localparam BYTE3  = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
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

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end

    // done combinational: high for one cycle immediately after receiving third byte
    assign done = (state == BYTE3);

endmodule