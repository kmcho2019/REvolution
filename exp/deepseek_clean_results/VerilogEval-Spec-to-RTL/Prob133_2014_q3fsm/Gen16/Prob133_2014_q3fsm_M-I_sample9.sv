module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] pos_cnt;
    reg [1:0] ones_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            ones_count <= 2'b0;
        end else begin
            case (state)
                A: begin
                    if (s) state <= B;
                    pos_cnt <= 2'b0;
                    ones_count <= 2'b0;
                end
                B: begin
                    pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : pos_cnt + 1'b1;
                    if (w) begin
                        ones_count <= (pos_cnt == 2'b10) ? {1'b0, w} : ones_count + 1'b1;
                    end else begin
                        ones_count <= (pos_cnt == 2'b10) ? 2'b0 : ones_count;
                    end
                end
            endcase
        end
    end

    // Combinational outputs
    assign z = (state == B) && (pos_cnt == 2'b00) && (ones_count == 2'b10);

endmodule