module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam S0 = 3'd0; // 000
    localparam S1 = 3'd1; // 001
    localparam S2 = 3'd2; // 010
    localparam S3 = 3'd3; // 011
    localparam S4 = 3'd4; // 100

    reg [2:0] state, next_state;

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state and output derived together
    always @(*) begin
        // Default assignments
        next_state = S0;
        z = 1'b0;

        if (state == S0) begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
            z = 1'b0;
        end else if (state == S1) begin
            if (x)
                next_state = S4;
            else
                next_state = S1;
            z = 1'b0;
        end else if (state == S2) begin
            if (x)
                next_state = S1;
            else
                next_state = S2;
            z = 1'b0;
        end else if (state == S3) begin
            if (x)
                next_state = S2;
            else
                next_state = S1;
            z = 1'b1;
        end else if (state == S4) begin
            if (x)
                next_state = S4;
            else
                next_state = S3;
            z = 1'b1;
        end else begin
            // Unknown state fallback
            next_state = S0;
            z = 1'b0;
        end
    end

endmodule