module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam S0 = 2'b00; // Initial state
    localparam S1 = 2'b01; // Received '1'
    localparam S2 = 2'b10; // Received '11'
    localparam S3 = 2'b11; // Received '110'

    reg [1:0] state, next_state;
    wire state_clk_en = !start_shifting;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else if (state_clk_en) begin
            state <= next_state;
        end
    end

    // Output logic (combinational)
    assign start_shifting = (state == S3) && data;

endmodule