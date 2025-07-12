module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;
    
    // Counter for cycles in state B (0-2)
    reg [1:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b0;
            cycle_count <= 2'b0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= {w_history[1:0], w};
                        cycle_count <= 2'b1;
                        z <= 1'b0;
                    end
                end
                
                B: begin
                    if (cycle_count == 2'b10) begin
                        // Check if exactly two 1's in last 3 cycles
                        z <= ((w_history[0] + w_history[1] + w) == 2);
                        cycle_count <= 2'b0;
                        w_history <= 3'b0;
                    end else begin
                        cycle_count <= cycle_count + 1;
                        z <= 1'b0;
                    end
                    // Always shift in new w value
                    w_history <= {w_history[1:0], w};
                end
            endcase
        end
    end

endmodule