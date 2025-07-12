module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg d_reg;          // Sampled input at posedge clk
    reg clk_dly;        // Delayed clock for edge detection

    wire falling_edge;

    // Sample input 'd' at posedge clk
    always @(posedge clk) begin
        d_reg <= d;
        clk_dly <= clk; // Delay clock for edge detection
    end

    // Detect falling edge: clk goes from 1 to 0
    assign falling_edge = (clk_dly == 1'b1) && (clk == 1'b0);

    // Update output on posedge clk or on detected falling edge
    always @(posedge clk) begin
        // On rising edge: q follows d
        q <= d_reg;
    end

    // Update output on falling edge via asynchronous process using falling_edge
    // Since we can't use negedge clk always block, we use a synchronous approach:
    // On next rising edge after falling edge detected, update q to d_reg (already done)
    // To implement immediate update on falling edge, we use a combinational latch style:
    always @(*) begin
        // If falling edge detected, force q to d_reg
        if (falling_edge) begin
            q = d_reg;
        end
    end

endmodule