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
            // Shift in current 'a'
            a_shift <= {a_shift[0], a};

            // Detect rising edge: previous was 0, current is 1
            rise <= (a_shift == 2'b01);

            // Detect falling edge: previous was 1, current is 0
            down <= (a_shift == 2'b10);
        end
    end

endmodule