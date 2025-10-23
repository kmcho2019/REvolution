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

    reg [1:0] current_state, next_state;
    reg found;

    // Next state logic
    always @(*) begin
        if (found) begin
            next_state = current_state; // Freeze state after detection
        end else begin
            case (current_state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S1 : S0;
                default: next_state = S0;
            endcase
        end
    end

    // State transition and found logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            found <= 1'b0;
        end else begin
            current_state <= next_state;
            if (!found) begin
                found <= (current_state == S3) && data;
            end
        end
    end

    assign start_shifting = found;

endmodule