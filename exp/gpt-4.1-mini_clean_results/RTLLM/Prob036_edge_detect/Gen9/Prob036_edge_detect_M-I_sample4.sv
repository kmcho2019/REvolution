module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;

    // Synchronize input 'a' to clk domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    // Generate one-clock-cycle pulses on rise and down on next clk after edge detected
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (a_sync == 2'b01);
            down <= (a_sync == 2'b10);
        end
    end

endmodule