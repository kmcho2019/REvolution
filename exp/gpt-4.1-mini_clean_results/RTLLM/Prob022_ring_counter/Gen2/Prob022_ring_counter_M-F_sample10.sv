module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    integer i;
    reg [7:0] next_out;

    always @(posedge clk) begin
        if (reset) begin
            // Assign each bit separately to avoid full vector assignment
            out[0] <= 1'b1;
            for (i = 1; i < 8; i = i + 1)
                out[i] <= 1'b0;
        end else begin
            // Compute next state
            if (out[7])
                next_out = 8'b00000001;
            else
                next_out = out << 1;

            // Assign each bit separately to avoid full vector assignment
            for (i = 0; i < 8; i = i + 1)
                out[i] <= next_out[i];
        end
    end

endmodule