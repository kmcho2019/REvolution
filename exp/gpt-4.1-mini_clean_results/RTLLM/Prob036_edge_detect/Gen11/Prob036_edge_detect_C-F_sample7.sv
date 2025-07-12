module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;

    // Synchronize 'a' to clk domain with 2 flip-flops
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    wire rising_edge  = (~a_sync[1]) & a_sync[0];
    wire falling_edge = a_sync[1] & (~a_sync[0]);

    // Register outputs: pulse rise or down on the clock cycle AFTER the edge is detected
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rising_edge;
            down <= falling_edge;
        end
    end

endmodule