module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [0:0] {IDLE = 1'b0, COUNTING = 1'b1} state_t;
    reg [1:0] count;
    reg state;

    wire start_byte = in[3];

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done deasserted every cycle

            case(state)
                IDLE: begin
                    count <= 2'd0;
                    if (start_byte) begin
                        state <= COUNTING;
                        count <= 2'd1;
                    end
                end

                COUNTING: begin
                    count <= count + 1'b1;
                    if (count == 2'd2) begin
                        // After receiving third byte (count=3), assert done and go back to IDLE
                        done <= 1'b1;
                        state <= IDLE;
                        count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule