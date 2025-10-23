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
    reg [1:0] count_w;    // counts number of w=1 in the current 3-cycle window (max 3)
    reg [1:0] cycle_cnt;  // counts cycles 0 to 2

    // z registered, output one cycle after counting window
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            count_w   <= 2'd0;
            cycle_cnt <= 2'd0;
            z         <= 1'b0;
            z_next    <= 1'b0;
        end else begin
            z <= z_next; // update output z
            
            case(state)
                A: begin
                    z_next <= 1'b0; // no output in A
                    if (s == 1'b1) begin
                        state <= B;
                        count_w <= (w == 1'b1) ? 2'd1 : 2'd0;
                        cycle_cnt <= 2'd0;
                    end else begin
                        state <= A;
                        count_w <= 2'd0;
                        cycle_cnt <= 2'd0;
                    end
                end
                
                B: begin
                    // count w=1 for current cycle only if cycle_cnt < 2
                    if (cycle_cnt < 2) begin
                        count_w <= count_w + (w == 1'b1 ? 1'b1 : 1'b0);
                        cycle_cnt <= cycle_cnt + 1;
                        z_next <= 1'b0; // no output yet
                    end else begin
                        // This is the 3rd sample (cycle_cnt == 2)
                        // Add last w to count_w and output in next cycle z=1 if exactly two w=1
                        // But here cycle_cnt == 2 means we haven't added current w yet, so add it now:
                        // So final count_w = current count_w + current w
                        // Then output z_next accordingly
                        // Then reset counters for next window
                        
                        // Compute final count with current w
                        reg [1:0] final_count;
                        final_count = count_w + (w == 1'b1 ? 1'b1 : 1'b0);
                        
                        z_next <= (final_count == 2) ? 1'b1 : 1'b0;
                        
                        // reset counters for next 3-cycle window
                        count_w <= 2'd0;
                        cycle_cnt <= 2'd0;
                    end
                end
                
                default: begin
                    state <= A;
                    count_w <= 2'd0;
                    cycle_cnt <= 2'd0;
                    z_next <= 1'b0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule