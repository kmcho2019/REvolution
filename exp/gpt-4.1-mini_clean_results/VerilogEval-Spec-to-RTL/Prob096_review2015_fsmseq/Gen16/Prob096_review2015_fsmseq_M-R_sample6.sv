module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // Binary encoded states
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' final sticky

    reg [2:0] state, next_state;

    // Next state and output logic - combinational always block
    always @(*) begin
        start_shifting = 1'b0; // default output
        case (state)
            S0: begin
                next_state = data ? S1 : S0;
            end
            S1: begin
                next_state = data ? S2 : S0;
            end
            S2: begin
                next_state = data ? S2 : S3;
            end
            S3: begin
                next_state = data ? S4 : S0;
            end
            S4: begin
                next_state = S4;
                start_shifting = 1'b1;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule