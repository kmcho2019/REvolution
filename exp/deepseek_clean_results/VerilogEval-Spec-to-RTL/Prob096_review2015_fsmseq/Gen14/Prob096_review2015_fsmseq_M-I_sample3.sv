module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam S0 = 4'b0001;  // Initial state
    localparam S1 = 4'b0010;  // Received '1'
    localparam S2 = 4'b0100;  // Received '11'
    localparam S3 = 4'b1000;  // Received '110'
    
    reg [3:0] state, next_state;
    wire enable = !start_shifting;  // Only update state when not detected yet

    // State transition logic
    always @(*) begin
        if (reset) begin
            next_state = S0;
        end else if (enable) begin
            case (state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S1 : S0;
                default: next_state = S0;
            endcase
        end else begin
            next_state = state;
        end
    end

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (enable && (state == S3) && data) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule