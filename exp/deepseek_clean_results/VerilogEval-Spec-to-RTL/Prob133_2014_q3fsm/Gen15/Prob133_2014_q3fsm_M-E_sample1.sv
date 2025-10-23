module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg [1:0] state;
    localparam A      = 2'b00;
    localparam B_WAIT = 2'b01;  // Collecting w values
    localparam B_EVAL = 2'b10;  // Evaluation state

    // Cycle counter and 1's counter
    reg [1:0] cycle_count;
    reg [1:0] ones_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            ones_count <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    if (s) begin
                        state <= B_WAIT;
                        cycle_count <= 2'b00;
                        ones_count <= w ? 2'b01 : 2'b00;
                    end
                end
                
                B_WAIT: begin
                    if (cycle_count == 2'd2) begin
                        state <= B_EVAL;
                        z <= (ones_count + w) == 2'd2;  // Final count
                    end else begin
                        ones_count <= ones_count + w;
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                
                B_EVAL: begin
                    state <= B_WAIT;
                    cycle_count <= 2'b00;
                    ones_count <= w ? 2'b01 : 2'b00;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule