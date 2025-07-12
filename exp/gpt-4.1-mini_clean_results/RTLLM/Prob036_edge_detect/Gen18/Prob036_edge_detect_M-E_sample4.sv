module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_shift <= 2'b00;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_shift <= {a_shift[0], a};
            // Detect rising edge: 0 -> 1
            if (a_shift == 2'b01) begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            // Detect falling edge: 1 -> 0
            else if (a_shift == 2'b10) begin
                rise <= 1'b0;
                down <= 1'b1;
            end
            // No edge detected, clear outputs
            else begin
                rise <= 1'b0;
                down <= 1'b0;
            end
        end
    end

endmodule