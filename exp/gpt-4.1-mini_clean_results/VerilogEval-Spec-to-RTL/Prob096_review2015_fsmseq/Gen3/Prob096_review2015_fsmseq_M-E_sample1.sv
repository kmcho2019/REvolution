module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // sequence found, sticky

    reg [2:0] state, next_state;
    reg next_start;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_start = 1'b0;

        case(state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (~data)
                    next_state = S3;
                else
                    next_state = S2;
            end
            S3: begin
                if (data) begin
                    next_state = S4;
                    next_start = 1'b1; // Mealy output asserted immediately upon detection
                end else
                    next_state = S0;
            end
            S4: begin
                next_state = S4;
                next_start = 1'b1; // sticky output
            end
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            start_shifting <= next_start;
        end
    end

endmodule