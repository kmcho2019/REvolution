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
    reg [1:0] cycle_cnt; // counts from 0 to 2 for 3 cycles
    reg [1:0] w_count;   // counts w=1 in current 3-cycle group

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'b00;
                    w_count <= 2'b00;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end
                B: begin
                    cycle_cnt <= cycle_cnt + 1'b1;
                    w_count <= w_count + w;
                    if (cycle_cnt == 2) begin
                        // After 3rd cycle (counting from 0), output z
                        z <= (w_count + w == 2) ? 1'b1 : 1'b0;
                        cycle_cnt <= 2'b00;
                        w_count <= 2'b00;
                    end else begin
                        z <= 1'b0;
                        state <= B;
                    end
                end
                default: begin
                    state <= A;
                    cycle_cnt <= 2'b00;
                    w_count <= 2'b00;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule