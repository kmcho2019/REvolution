module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state;
    reg [1:0] cycle_count;
    reg [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            z <= 1'b0; // default output

            case (state)
                A: begin
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end
                B: begin
                    if (cycle_count < 2) begin
                        cycle_count <= cycle_count + 1;
                        w_count <= w_count + w;
                    end else begin
                        // End of 3-cycle window
                        cycle_count <= 2'd0;
                        // Check if exactly 2 out of 3 w inputs were 1
                        if (w_count + w == 2) 
                            z <= 1'b1;
                        else
                            z <= 1'b0;
                        w_count <= 2'd0;
                    end
                    state <= B; // stay in B
                end
            endcase
        end
    end

endmodule