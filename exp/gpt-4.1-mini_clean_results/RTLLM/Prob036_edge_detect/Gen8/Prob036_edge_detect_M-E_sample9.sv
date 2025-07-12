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

            // Default outputs to 0; set to 1 when edge detected in previous cycle
            rise <= 1'b0;
            down <= 1'b0;

            if (a_shift == 2'b01)  // previous = 0, current = 1 → rising edge detected last cycle
                rise <= 1'b1;
            else if (a_shift == 2'b10) // previous = 1, current = 0 → falling edge detected last cycle
                down <= 1'b1;
        end
    end

endmodule