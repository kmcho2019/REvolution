module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_cnt; // counts from 0 to 2
    reg [1:0] w_count;   // counts how many times w=1 in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_count <= 2'd0;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    if (cycle_cnt == 2) begin
                        // On third cycle, output z if exactly two w=1 detected
                        z <= (w_count + w == 2);
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 1'b1;
                        w_count <= w_count + w;
                    end
                    state <= B;
                end

                default: begin
                    // Defensive reset in case of unknown state
                    state <= A;
                    cycle_cnt <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule