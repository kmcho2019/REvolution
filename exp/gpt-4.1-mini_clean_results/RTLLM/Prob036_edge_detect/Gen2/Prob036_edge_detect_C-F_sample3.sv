module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;    // 2-stage synchronizer for 'a'
    reg       a_d;       // delayed synchronized 'a'

    // Synchronize input 'a' asynchronously with 2-flip-flop synchronizer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    // Edge detection logic with registered outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Default clear outputs each cycle
            rise <= 1'b0;
            down <= 1'b0;

            // Detect edges comparing delayed synchronized signals
            if (~a_d & a_sync[1])       // rising edge detected on 'a_sync[1]'
                rise <= 1'b1;
            else if (a_d & ~a_sync[1])  // falling edge detected
                down <= 1'b1;

            // Update delayed synchronized 'a' for next cycle edge detection
            a_d <= a_sync[1];
        end
    end

endmodule