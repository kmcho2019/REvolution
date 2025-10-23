module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;

    // Synchronize input 'a' to clk domain using 2-stage synchronizer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    // Registered edge detection outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_sync[1]) & a_sync[0]; // rising edge detected
            down <= a_sync[1] & (~a_sync[0]); // falling edge detected
        end
    end

endmodule