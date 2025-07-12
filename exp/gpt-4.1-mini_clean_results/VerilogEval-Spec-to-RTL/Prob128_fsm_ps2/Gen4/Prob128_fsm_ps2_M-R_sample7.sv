module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    localparam IDLE   = 2'd0;
    localparam COUNT1 = 2'd1;
    localparam COUNT2 = 2'd2;

    reg [1:0] state, next_state;
    reg next_done;

    // Sequential block: state and done register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= next_done;
        end
    end

    // Combinational block: next state and done logic
    always @(*) begin
        next_state = state;
        next_done = 1'b0;

        case(state)
            IDLE: begin
                if (in[3])
                    next_state = COUNT1;
            end
            COUNT1: begin
                next_state = COUNT2;
            end
            COUNT2: begin
                next_done = 1'b1;  // done asserted after third byte received
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule