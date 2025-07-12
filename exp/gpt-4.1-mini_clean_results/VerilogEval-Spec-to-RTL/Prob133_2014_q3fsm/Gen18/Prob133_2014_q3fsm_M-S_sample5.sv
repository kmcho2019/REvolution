module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] count;
    reg [1:0] w_sum;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            w_sum <= 2'd0;
            z <= 1'b0;
        end else begin
            z <= 1'b0;  // default output
            case(state)
                A: begin
                    count <= 2'd0;
                    w_sum <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    if (count == 2) begin
                        z <= ((w_sum + w) == 2);
                        count <= 2'd0;
                        w_sum <= 2'd0;
                    end else begin
                        count <= count + 1;
                        w_sum <= w_sum + w;
                    end
                end
            endcase
        end
    end
endmodule