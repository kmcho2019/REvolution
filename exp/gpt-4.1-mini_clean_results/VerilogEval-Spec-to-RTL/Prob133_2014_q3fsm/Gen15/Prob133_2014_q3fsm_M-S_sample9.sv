module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic {A, B} state_t;
    state_t state;
    reg [1:0] cycle_cnt;
    reg [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            cycle_cnt <= 2'd0;
            w_count   <= 2'd0;
            z         <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z         <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_count   <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    z <= 1'b0;
                    cycle_cnt <= cycle_cnt + 1;
                    w_count <= w_count + w;
                    if (cycle_cnt == 2) begin
                        z <= ((w_count + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule