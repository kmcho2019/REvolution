module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_shift;

    // Track if rise/down was already signaled since last respective edge
    reg rise_done, down_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_shift   <= 2'b00;
            rise      <= 1'b0;
            down      <= 1'b0;
            rise_done <= 1'b0;
            down_done <= 1'b0;
        end else begin
            // Shift in the current input
            a_shift <= {a_shift[0], a};

            // Default outputs to remain asserted if done and no new edge
            rise <= rise_done;
            down <= down_done;

            // Detect rising edge: transition 0->1 in a_shift[1:0]
            if (a_shift == 2'b01) begin
                rise      <= 1'b1;     // pulse rise high
                rise_done <= 1'b1;     // mark rise detected and signaled
                down_done <= 1'b0;     // reset down done because edges are independent
            end
            // Detect falling edge: transition 1->0 in a_shift[1:0]
            else if (a_shift == 2'b10) begin
                down      <= 1'b1;     // pulse down high
                down_done <= 1'b1;     // mark down detected and signaled
                rise_done <= 1'b0;     // reset rise done
            end
            // If no edge detected, keep rise/down asserted if already done
            else begin
                // Hold previous state of rise/down outputs to keep them high until next edge resets
                rise <= rise_done;
                down <= down_done;
            end
        end
    end

endmodule