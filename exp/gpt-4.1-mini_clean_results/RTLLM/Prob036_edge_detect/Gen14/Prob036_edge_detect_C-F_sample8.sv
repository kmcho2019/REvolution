module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    // Register input 'a' to detect edges synchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Register outputs to create one-cycle pulses on edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d) & a;  // rising edge: previous low, current high
            down <= a_d & (~a);  // falling edge: previous high, current low
        end
    end

endmodule