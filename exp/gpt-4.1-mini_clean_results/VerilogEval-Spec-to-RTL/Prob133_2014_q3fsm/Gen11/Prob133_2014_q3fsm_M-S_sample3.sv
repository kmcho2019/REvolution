module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    localparam A = 1'b0, B = 1'b1;
    reg state;
    reg [1:0] cycle;   // counts cycles 0..2
    reg [1:0] w_acc;   // accumulates w count over 3 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle <= 2'd0;
            w_acc <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle <= 2'd0;
                    w_acc <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    w_acc <= w_acc + w;
                    if (cycle == 2) begin
                        z <= (w_acc + w == 2);
                        cycle <= 2'd0;
                        w_acc <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle <= cycle + 1;
                    end
                end
            endcase
        end
    end

endmodule