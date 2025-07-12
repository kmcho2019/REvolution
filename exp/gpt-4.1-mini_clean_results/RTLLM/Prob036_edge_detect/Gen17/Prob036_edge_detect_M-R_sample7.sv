module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // Registered output for rising edge pulse
    output reg  down    // Registered output for falling edge pulse
);

    reg a_prev;

    // Sequential logic block: update previous 'a' and generate outputs synchronized to clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Detect rising edge: a_prev=0 and a=1
            rise <= (~a_prev) & a;
            // Detect falling edge: a_prev=1 and a=0
            down <= a_prev & (~a);
            // Update previous input
            a_prev <= a;
        end
    end

endmodule