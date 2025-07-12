module TopModule (
    input clk,
    input reset,
    input s,
    input w,
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
            z <= 1'b0; // default no output
            case(state)
                A: begin
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    if (cycle_count < 2) begin
                        cycle_count <= cycle_count + 1'b1;
                        w_count <= w_count + w;
                    end else begin
                        // cycle_count == 2: output z if exactly two w's in the 3 cycles (including this one)
                        z <= (w_count + w == 2);
                        cycle_count <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule