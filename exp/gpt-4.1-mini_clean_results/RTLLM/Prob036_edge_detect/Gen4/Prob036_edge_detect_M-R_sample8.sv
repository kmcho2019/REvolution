module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    // Register 'a' to create a delayed version
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    // Combinational detection of edges
    wire rise_comb = (~a_dly) & a;   // rising edge detected
    wire down_comb = a_dly & (~a);   // falling edge detected

    // Register the edge signals to synchronize them with clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_comb;
            down <= down_comb;
        end
    end

endmodule