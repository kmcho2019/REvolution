module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] state, next_state;

    // Combinational logic: rotate one-hot state left by 1 with wrap-around
    always @(*) begin
        // If reset asserted, next_state ignored here; handled in sequential block
        if (state == 10'b1000000000)
            next_state = 10'b0000000001;
        else
            next_state = state << 1;
    end

    // Sequential logic: synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001;
        else
            state <= next_state;
    end

    // Decode one-hot state to binary output q
    always @(*) begin
        case (state)
            10'b0000000001: q = 4'd0;
            10'b0000000010: q = 4'd1;
            10'b0000000100: q = 4'd2;
            10'b0000001000: q = 4'd3;
            10'b0000010000: q = 4'd4;
            10'b0000100000: q = 4'd5;
            10'b0001000000: q = 4'd6;
            10'b0010000000: q = 4'd7;
            10'b0100000000: q = 4'd8;
            10'b1000000000: q = 4'd9;
            default:        q = 4'd0; // default safe state
        endcase
    end

endmodule