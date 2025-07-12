module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {IDLE=2'd0, COUNT1=2'd1, COUNT2=2'd2} state_t;
    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done deassert
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= COUNT1;
                end
                COUNT1: begin
                    state <= COUNT2;
                end
                COUNT2: begin
                    done <= 1'b1;   // assert done after third byte
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule