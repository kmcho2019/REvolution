module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_sync;

    // Synchronize input 'a' to clk domain using a 2-flip-flop synchronizer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_sync <= 2'b00;
        else
            a_sync <= {a_sync[0], a};
    end

    // Edge detection signals (combinational)
    wire rising_edge  = (~a_sync[1]) & a_sync[0];
    wire falling_edge = a_sync[1] & (~a_sync[0]);

    // Store rise/down outputs; 
    // rise is set on rising edge and cleared on falling edge
    // down is set on falling edge and cleared on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            if (rising_edge) begin
                rise <= 1'b1;
                down <= 1'b0;
            end else if (falling_edge) begin
                down <= 1'b1;
                rise <= 1'b0;
            end
            // else hold previous values
        end
    end

endmodule