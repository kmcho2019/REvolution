module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg [1:0] cycle_count;
    reg [1:0] ones_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_count <= 2'b0;
            ones_count <= 2'b0;
        end else begin
            case (state)
                STATE_A: begin
                    if (s) begin
                        state <= STATE_B;
                        cycle_count <= 2'b0;
                        ones_count <= 2'b0;
                    end
                end
                STATE_B: begin
                    cycle_count <= cycle_count + 1'b1;
                    if (w) ones_count <= ones_count + 1'b1;
                    
                    if (cycle_count == 2'b10) begin
                        cycle_count <= 2'b0;
                        ones_count <= 2'b0;
                    end
                end
            endcase
        end
    end

    assign z = (state == STATE_B) && (cycle_count == 2'b10) && (ones_count == 2'd2);

endmodule