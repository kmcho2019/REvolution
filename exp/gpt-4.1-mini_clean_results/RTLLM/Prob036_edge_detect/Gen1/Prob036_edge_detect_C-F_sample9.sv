module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_dly <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Detect edges using previous and current 'a'
            rise <= (~a_dly) & a;    // Rising edge: prev=0, curr=1
            down <= a_dly & (~a);    // Falling edge: prev=1, curr=0
            a_dly <= a;
        end
    end

endmodule