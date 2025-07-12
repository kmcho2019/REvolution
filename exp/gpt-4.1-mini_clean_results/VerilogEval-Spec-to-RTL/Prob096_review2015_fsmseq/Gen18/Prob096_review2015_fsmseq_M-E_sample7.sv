module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam S0 = 5'b00001; // no match
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '11'
    localparam S3 = 5'b01000; // matched '110'
    localparam S4 = 5'b10000; // matched '1101' final sticky

    reg [4:0] state, next_state;

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (data)
                        state <= S1;
                    else
                        state <= S0;
                    start_shifting <= 1'b0;
                end
                S1: begin
                    if (data)
                        state <= S2;
                    else
                        state <= S0;
                    start_shifting <= 1'b0;
                end
                S2: begin
                    if (data)
                        state <= S2;
                    else
                        state <= S3;
                    start_shifting <= 1'b0;
                end
                S3: begin
                    if (data)
                        state <= S4;
                    else
                        state <= S0;
                    start_shifting <= 1'b0;
                end
                S4: begin
                    state <= S4;
                    start_shifting <= 1'b1;
                end
                default: begin
                    state <= S0;
                    start_shifting <= 1'b0;
                end
            endcase
        end
    end

endmodule