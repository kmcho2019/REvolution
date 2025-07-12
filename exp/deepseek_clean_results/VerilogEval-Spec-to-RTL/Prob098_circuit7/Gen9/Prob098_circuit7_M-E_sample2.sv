module TopModule (
    input clk,
    input a,
    output reg q
);

// State definitions
localparam WAIT_FOR_0 = 1'b0;
localparam WAIT_FOR_1 = 1'b1;

reg state;

initial begin
    state = WAIT_FOR_0;
    q = 1'b0;
end

always @(posedge clk) begin
    case (state)
        WAIT_FOR_0: begin
            if (~a) begin
                q <= 1'b1;
                state <= WAIT_FOR_1;
            end
        end
        WAIT_FOR_1: begin
            if (a) begin
                q <= 1'b0;
                // Stay in this state forever after
            end
        end
    endcase
end

endmodule