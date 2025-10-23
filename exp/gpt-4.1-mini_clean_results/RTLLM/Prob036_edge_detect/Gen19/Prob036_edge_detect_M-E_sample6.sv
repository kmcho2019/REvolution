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

            // Detect rising edge: previous = 0, current = 1
            if (a_shift == 2'b01)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            // Detect falling edge: previous = 1, current = 0
            if (a_shift == 2'b10)
                down <= 1'b1;
            else
                down <= 1'b0;
        end
    end

endmodule