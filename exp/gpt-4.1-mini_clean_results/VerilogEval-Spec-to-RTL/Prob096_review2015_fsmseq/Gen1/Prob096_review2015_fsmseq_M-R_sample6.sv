module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam S0 = 3'b000; // no match yet
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'
    localparam S4 = 3'b100; // matched '1101' (final state)

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
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
                if (data)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                next_state = S4; // sticky final state
            end
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: combinational and purely from state
    assign start_shifting = (state == S4);

endmodule