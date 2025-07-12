module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    reg state; // 0: A, 1: B
    reg [1:0] sample_count; // 0 to 2
    reg [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state        <= 1'b0;  // A
            sample_count <= 2'd0;
            w_count      <= 2'd0;
            z            <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // State A: wait for s=1
                    z <= 1'b0;
                    sample_count <= 2'd0;
                    w_count <= 2'd0;
                    if (s) state <= 1'b1; // move to B
                end
                1'b1: begin // State B: sample w 3 times
                    if (sample_count < 2'd2) begin
                        sample_count <= sample_count + 2'd1;
                        w_count <= w_count + w;
                        z <= 1'b0;
                    end else begin
                        // After 3rd sample, output z = 1 if exactly 2 ones among w samples
                        z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                        sample_count <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule