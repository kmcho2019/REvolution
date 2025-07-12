module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_shift;

    // Shift register for 'a' to capture current and previous states
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_shift <= 2'b00;
        else
            a_shift <= {a_shift[0], a};
    end

    // Registers to hold the rise and down signals until next edge detected
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge: previous was 0, current is 1
            if (a_shift == 2'b01)
                rise <= 1'b1;
            else if (rise)
                rise <= 1'b0;

            // Detect falling edge: previous was 1, current is 0
            if (a_shift == 2'b10)
                down <= 1'b1;
            else if (down)
                down <= 1'b0;
        end
    end

endmodule