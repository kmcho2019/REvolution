module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding (2-bit binary)
    localparam IDLE   = 2'd0;
    localparam COUNT1 = 2'd1;
    localparam COUNT2 = 2'd2;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done only one cycle immediately after third byte received
            done <= (state == COUNT2);
        end
    end

    always @(*) begin
        case (state)
            IDLE:   next_state = in[3] ? COUNT1 : IDLE;
            COUNT1: next_state = COUNT2;
            COUNT2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule