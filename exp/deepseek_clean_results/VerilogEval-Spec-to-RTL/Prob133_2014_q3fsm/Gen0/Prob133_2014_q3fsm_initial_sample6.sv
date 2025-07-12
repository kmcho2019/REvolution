module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // States
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;
    reg [1:0] cycle_count;
    reg [1:0] w_count;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                STATE_A: begin
                    z <= 1'b0;
                    if (s) begin
                        state <= STATE_B;
                        cycle_count <= 2'b00;
                        w_count <= 2'b00;
                    end
                end
                
                STATE_B: begin
                    if (cycle_count == 2'b10) begin
                        // End of 3-cycle period
                        z <= (w_count == 2'b10); // Check if exactly two 1's
                        cycle_count <= 2'b00;
                        w_count <= 2'b00;
                    end else begin
                        cycle_count <= cycle_count + 1;
                        z <= 1'b0;
                    end
                    
                    // Count w=1 occurrences
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end
            endcase
        end
    end

endmodule