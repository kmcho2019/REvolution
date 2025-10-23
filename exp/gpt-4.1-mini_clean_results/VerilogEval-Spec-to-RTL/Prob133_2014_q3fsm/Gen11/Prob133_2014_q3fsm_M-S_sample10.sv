module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_cnt; // 0..2
    reg [1:0] w_count;   // count of w=1 in current window

    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            cycle_cnt <= 2'd0;
            w_count   <= 2'd0;
            z         <= 1'b0;
        end else begin
            z <= 1'b0; // default output

            case (state)
                A: begin
                    cycle_cnt <= 2'd0;
                    w_count   <= 2'd0;
                    if (s)
                        state <= B;
                end

                B: begin
                    if (cycle_cnt < 2) begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                        w_count   <= w_count + w;
                    end else begin
                        // After 3rd w sample, output z next cycle
                        z         <= ((w_count + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_count   <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule