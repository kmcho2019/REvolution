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
    reg [2:0] w_history;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_history <= 3'b0;
        end else begin
            case (state)
                A: begin
                    if (s) state <= B;
                    pos_cnt <= 2'b0;
                    w_history <= 3'b0;
                end
                B: begin
                    pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : pos_cnt + 1'b1;
                    w_history <= {w_history[1:0], w};
                end
            endcase
        end
    end

    // Combinational outputs
    wire eval_now = (state == B) && (pos_cnt == 2'b00);
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = eval_now ? (ones_count == 2'd2) : 1'b0;

endmodule